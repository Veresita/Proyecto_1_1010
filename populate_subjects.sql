--------------------------SEMILLA.--------------------------------------
-- Insert rows into table 'subjects'
INSERT INTO subjects
( -- columns to insert data into
    code, subject_name, descrip, semester, required_subject
)
VALUES
( "PREF00", "PREFACULTATIVOS", "PREFAS INICIO", 0, 1); --1
---------------------PRIMER SEMESTRE-----------------------------------

INSERT INTO subjects
( code, subject_name, semester, required_subject)
VALUES
( "FIS100", "FISICA BASICA Y LABORATORIO", 1, 1 ), -- 2
( "MAT100", "ÁLGEBRA", 1, 1 ), -- 3
( "MAT101", "CÁLCULO 1", 1, 1 ), -- 4
( "QMC100", "QUÍMICA GENERAL Y LABORATORIO", 1, 1 ), -- 5
( "MEC101", "DIBUJO TÉCNICO", 1, 1 ), -- 6
( "ETN507", "HISTORIA CRÍTICA DE AMÉRICA LATINA", 1, 1 ); -- 7

---------------------SEGUNDO SEMESTRE-----------------------------------

INSERT INTO subjects
( code, subject_name, semester, required_subject)
VALUES
( "FIS102", "FISICA BASICA II Y LABORATORIO", 2, 2 ), -- 8
( "MAT102", "CÁLCULO 2", 2, 4 ), -- 9
( "MAT103", "ÁLGEBRA LINEAL Y TEORÍA MATRICIAL", 2, 3 ), -- 10
( "MAT218", "ANÁLISIS DE VARIABLE COMPLEJA", 2, 4 ), -- 11
( "ETN401", "PROBABILIDAD Y ESTADÍSTICA", 2, 3 ); -- 12

---------------------TERCER SEMESTRE-----------------------------------

INSERT INTO subjects
( code, subject_name, semester, required_subject)
VALUES
( "FIS102", "FISICA BASICA II Y LABORATORIO", 2, 2 ), -- 8
( "MAT102", "CÁLCULO 1", 2, 4 ), -- 9
( "MAT103", "ÁLGEBRA LINEAL Y TEORÍA MATRICIAL", 2, 3 ), -- 10
( "MAT218", "ANÁLISIS DE VARIABLE COMPLEJA", 2, 4 ), -- 11
( "ETN401", "PROBABILIDAD Y ESTADÍSTICA", 2, 3 ); -- 12

--  SELECT * FROM subjects;
--  DELETE FROM subjects WHERE subject_id=2;
--  DELETE FROM subjects WHERE subject_id>2;
--  ALTER TABLE subjects AUTO_INCREMENT = 2;
--  UPDATE subjects SET subject_name = "CÁLCULO 2" WHERE subject_id=9;