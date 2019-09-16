function varargout = students_insert(varargin)

% Last Modified by GUIDE v2.5 14-Sep-2019 02:35:12

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @students_insert_OpeningFcn, ...
                   'gui_OutputFcn',  @students_insert_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before students_insert is made visible.
function students_insert_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for students_insert
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes students_insert wait for user response (see UIRESUME)
% uiwait(handles.figure1);


% --- Outputs from this function are returned to the command line.
function varargout = students_insert_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;

function edit1_Callback(hObject, eventdata, handles)
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit2_Callback(hObject, eventdata, handles)
function edit2_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit3_Callback(hObject, eventdata, handles)
function edit3_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit4_Callback(hObject, eventdata, handles)
function edit4_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end
function edit5_Callback(hObject, eventdata, handles)
function edit5_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function pushbutton1_Callback(hObject, eventdata, handles)
    %Obtengo del GUI
    name = get(handles.edit1,'String');
    lastname = get(handles.edit2,'String');
    ru = get(handles.edit3,'String');
    ci = get(handles.edit4,'String');
    password = get(handles.edit5,'String');
    %ingreso en base de datos
    conn = database('university_db','root','');
        SQLQuery = cell2mat(strcat('INSERT INTO students (student_password, ru, ci, first_name, last_name) VALUES(', password,',', ru,',', ci,',"', name,'","', lastname,'");'))
        exec(conn,SQLQuery)
        fetch(conn,'SELECT * FROM students')
    close (conn)
