% [INPUT]
% query = A string representing a valid SQL query to be performed on one or more tables defined within the main workspace.
%         Only CRUD operations (DELETE, INSERT, SELECT and UPDATE) are supported.
%
% [OUTPUT]
% out  = The result of the specified SQL query, whose content depends upon the performed operation:
%         - for SELECT statements, an m-by-n table representing the result set returned by the database;
%         - for DELETE, INSERT and UPDATE statements, an integer representing the number of affected rows.

function out = table_sql(varargin)

    persistent p;

    if (isempty(p))
        p = inputParser();
        p.addRequired('query',@(x)validateattributes(x,{'char','string'},{'scalartext','nonempty'}));
    end

    p.parse(varargin{:});
    res = p.Results;

    query = strtrim(char(res.query));
    query_chunks = cellstr(regexpi(query,'[0-9A-Z._]+','match'));
    
    if (~any(strcmpi(query_chunks{1},{'DELETE' 'INSERT' 'SELECT' 'UPDATE'})))
        error('The script could not execute the specified query because only CRUD operations (DELETE, INSERT, SELECT and UPDATE) are supported.');
    end

    out = table_sql_internal(query,query_chunks);

end

function out = table_sql_internal(query,query_chunks)

    persistent drv;

    if (isempty(drv))
        [folder,~,~] = fileparts(which(mfilename()));

        sqlite_jar = dir([folder filesep() 'sqlite-jdbc-*.jar']);

        if (isempty(sqlite_jar))
            error('The script could not locate the SQLite JDBC driver.');
        end

        if (numel(sqlite_jar) > 1)
            error('The script must include only one SQLite JDBC driver.');
        end

        drv = fullfile(sqlite_jar.folder,sqlite_jar.name);

        if (isempty(cell2mat(regexpi(javaclasspath('-all'),[sqlite_jar.name '$']))))
            javaaddpath(drv);
        end
    end

    conn = database('','','','org.sqlite.JDBC','jdbc:sqlite::memory:');
    
    if (~isempty(conn.Message) || ~isopen(conn))
        error('The script failed to connect to the SQLite database.');
    end

    setdbprefs('DataReturnFormat','table');
    setdbprefs('NullStringRead','');
    setdbprefs('NullStringWrite','');

    vars = evalin('base','whos');
    vars_names = {vars.name};
    vars_istab = strcmp({vars.class},'table');

    table_names = query_chunks(cellfun(@(x)any(strcmp(vars_names,x) & vars_istab),query_chunks));

    for i = 1:numel(table_names)
        table_name = table_names{i};
        table_data = evalin('base',table_name);
        table_fields = table_data.Properties.VariableNames;

        tw_out = table_write(conn,table_name,table_fields,table_data);
        
        if (ischar(tw_out))
            close(conn);
            error(tw_out);
        end
        
        assignin('base',table_name,tw_out);
    end

    if (strcmpi(query_chunks{1},'SELECT'))
        curs = exec(conn,query);
        curs_err = strtrim(char(curs.Message()));

        if (~isempty(curs_err))
            close(curs);
            close(conn);
            error(['The script failed to execute the specified query.' char(10) curs_err]); %#ok<CHARTEN>
        end
        
        out = table_read(curs);

        close(curs);
    else
        curs = exec(conn,query);
        curs_err = strtrim(char(curs.Message()));

        if (~isempty(curs_err))
            close(curs);
            close(conn);
            error(['The script failed to execute the specified query.' char(10) curs_err]); %#ok<CHARTEN>
        end
        
        close(curs);
        
        curs = exec(conn,'SELECT CHANGES()');
        curs_err = strtrim(char(curs.Message()));

        if (~isempty(curs_err))
            close(curs);
            close(conn);
            error(['The script failed to execute the specified query.' char(10) curs_err]); %#ok<CHARTEN>
        end
        
        curs_fetch = fetch(curs);
        out = table2array(curs_fetch.Data);

        close(curs);
        
        for i = 1:numel(table_names)
            table_name = table_names{i};
            
            curs = exec(conn,['SELECT * FROM ' table_name]);
            curs_err = strtrim(char(curs.Message()));

            if (~isempty(curs_err))
                close(curs);
                close(conn);
                error(['The script failed to synchronize the table "' table_name '".' char(10) curs_err]); %#ok<CHARTEN>
            end

            assignin('base',table_name,table_read(curs));
        end
    end

end

function out = join_query_strings(str,del)

    str_len = numel(str);

    if (str_len == 0)
        out = '';
    else
        str = reshape(str,str_len,1);
        
        jc = cell(2,str_len);
        jc(1,:) = str;
        jc(2,1:str_len-1) = {del};

        out = [jc{:}];
    end

end

function out = table_read(curs)

    import('com.mathworks.toolbox.database.*');
    curs_meta = DatabaseResultsetMetaData(curs.ResultSet);
    curs_types = curs_meta.getAllColumnTypes();
    curs_dates = curs_types == 93;
    
    curs_fetch = fetch(curs);
    out = curs_fetch.Data;
    
    if (any(curs_dates))
        columns = sum(curs_dates);
        rows = height(out);

        dates_len = columns * rows;
        dates = NaT(dates_len,1);
        
        dates_vals = out{:,curs_dates};
        dates_vals = dates_vals(:);

        tz = java.util.TimeZone.getDefault();
        tzo = (tz.getRawOffset() + tz.getDSTSavings()) / 8.64e7;
        dates_nat = cellfun(@isempty,dates_vals);
        dates(~dates_nat) = datetime(((str2double(dates_vals(~dates_nat)) ./ 8.64e7) + 719529 + tzo),'ConvertFrom','datenum');
        
        dates = mat2cell(dates,ones(dates_len,1));
        dates = reshape(dates,rows,columns);

        out{:,curs_dates} = dates;
    end

end

function out = table_write(conn,table_name,table_fields,table_data)

    if (isempty(table_fields))
        out = ['The script could not create the table "' table_name '" because it contains no fields.'];
        return;
    end

    curs = exec(conn,['DROP TABLE IF EXISTS ' table_name]);
    curs_err = strtrim(char(curs.Message()));

    if (~isempty(curs_err))
        close(curs);
        out = ['The script could not create the table "' table_name '".' char(10) curs_err]; %#ok<CHARTEN>
        return;
    end

    close(curs);

    table_out = table_data;

    table_fields_len = numel(table_fields);
    table_types = cell(1,table_fields_len);

    for i = 1:table_fields_len
        table_field = table_fields{i};

        table_column = table_data.(table_field);
        table_column_type = class(table_column);
        
        switch (table_column_type)
            case 'categorical'
                table_data.(table_field) = strrep(cellstr(table_column),'<undefined>','');
                table_out.(table_field) = table_data.(table_field);
                table_types{i} = 'VARCHAR';
            case 'cell'
                table_column_len = numel(table_column);
                if (sum(cellfun(@isempty,table_column)) == table_column_len)
                    table_data.(table_field) = repmat({''},table_column_len,1);
                    table_out.(table_field) = table_data.(table_field);
                    table_types{i} = 'VARCHAR';
                elseif (iscellstr(table_column)) %#ok<ISCLSTR>
                    table_types{i} = 'VARCHAR';
                elseif (sum(cellfun(@isstring,table_column)) == table_column_len)
                    table_data.(table_field) = cellstr(table_column);
                    table_out.(table_field) = table_data.(table_field);
                    table_types{i} = 'VARCHAR';
                elseif (sum(cellfun(@(x)(isnumeric(x) && isscalar(x)),table_column)) == table_column_len)
                    table_data.(table_field) = cellfun(@double,table_column);
                    table_out.(table_field) = table_data.(table_field);
                    table_types{i} = 'FLOAT';
                elseif (sum(cellfun(@(x)(islogical(x) && isscalar(x)),table_column)) == table_column_len)
                    table_data.(table_field) = cellfun(@int8,table_column);
                    table_types{i} = 'BOOLEAN';
                elseif (sum(cellfun(@(x)(isdatetime(x) && isscalar(x)),table_column)) == table_column_len)
                    dates = [table_column{:}].';
                    dates_nat = isnat(dates);
                    table_data.(table_field)(dates_nat) = {''};
                    table_data.(table_field)(~dates_nat) = cellstr(datestr(dates(~dates_nat),'yyyy-mm-dd HH:MM:SS.FFF'));
                    table_types{i} = 'TIMESTAMP';
                else
                    out = ['The script could not create the table "' table_name '" because the field "' table_field '" has an invalid type (' table_column_type ').'];
                    return;
                end
            case 'datetime'
                dates = cell(numel(table_column),1);
                dates_nat = isnat(table_column);
                dates(dates_nat) = {''};
                dates(~dates_nat) = cellstr(datestr(table_column(~dates_nat),'yyyy-mm-dd HH:MM:SS.FFF'));
                table_data.(table_field) = dates;
                table_types{i} = 'TIMESTAMP';
            case {'double','int8','int16','int32','int64','single','uint8','uint16','uint32','uint64'}
                table_data.(table_field) = double(table_column);
                table_out.(table_field) = table_data.(table_field);
                table_types{i} = 'FLOAT';
            case 'logical'
                table_data.(table_field) = int8(table_column);
                table_types{i} = 'BOOLEAN';
            case 'string'
                table_data.(table_field) = cellstr(table_column);
                table_out.(table_field) = table_data.(table_field);
                table_types{i} = 'VARCHAR';
            otherwise
                out = ['The script could not create the table "' table_name '" because the field "' table_field '" has an invalid type (' table_column_type ').'];
                return;
        end
    end
    
	create_query = ['CREATE TABLE ' table_name ' ('];

	for i = 1:table_fields_len
        if (i == 1)
            create_query = [create_query table_fields{i} ' ' table_types{i} ',']; %#ok<AGROW>
        elseif (i == table_fields_len)
            create_query = [create_query ' ' table_fields{i} ' ' table_types{i}]; %#ok<AGROW>
        else
            create_query = [create_query ' ' table_fields{i} ' ' table_types{i} ',']; %#ok<AGROW>
        end
	end

    create_query = [create_query ')'];

    curs = exec(conn,create_query);
    curs_err = strtrim(char(curs.Message()));

    if (~isempty(curs_err))
        close(curs);
        out = ['The script could not create the table "' table_name '".' char(10) curs_err]; %#ok<CHARTEN>
        return;
    end

    close(curs);

    import('com.mathworks.toolbox.database.*');
    
    meta_query = ['SELECT * FROM ' table_name ' LIMIT 1'];
    meta_stmt = conn.Constructor.prepareStatement(meta_query);
    meta_stmt_cu = onCleanup(@()close(meta_stmt));
    meta_rs = DatabaseResultsetMetaData(meta_stmt);

    if (~isempty(meta_rs.getErrorMessage()))
        out = ['The script could not create the table "' table_name '" because its metadata could not be retrieved.'];
        return;
    end

    insert_query = ['INSERT INTO ' table_name ' (' join_query_strings(table_fields,',') ') VALUES (' join_query_strings(repmat({'?'},table_fields_len,1),',') ')'];
    insert_stmt = DatabaseStatement(conn.Handle,conn.Constructor.prepareStatement(insert_query));
    insert_stmt_cu = onCleanup(@()closeStatement(insert_stmt));

    ac_old = conn.AutoCommit;
    conn.AutoCommit = 'off';

    insert_stmt.insert(width(table_data),height(table_data),meta_rs.getAllColumnTypes(),table2cell(table_data));

    eh_old = setdbprefs('ErrorHandling');
    setdbprefs('ErrorHandling','store');
    
    insert_err = strtrim(char(insert_stmt.getErrorExecutingStatement()));

    if (isempty(insert_err))
        commit(conn);

        conn.AutoCommit = ac_old;
        setdbprefs('ErrorHandling',eh_old);
        
        out = table_out;
    else
        rollback(conn);

        curs = exec(conn,['DROP TABLE ' table_name]);
        close(curs);

        conn.AutoCommit = ac_old;
        setdbprefs('ErrorHandling',eh_old);
        
        out = ['The script could not create the table "' table_name '".' char(10) insert_err]; %#ok<CHARTEN>
    end

end