-- Los nombres y gran parte de los comentarios están en inglés
-- esto debido a que en programación suele ser más práctico
-- y también debido a que así diseñé la base de datos.
-----------------------------------------------------------------------------
-- Create a new database called 'University'
CREATE DATABASE university
-- Sentencias para acceder facilmente:
--      SHOW DATABASES;
--      USE university;
--      SHOW TABLES;
-----------------------------------------------------------------------------
-- Create all the tables: Se trató de normalizar la base de datos
-- para que sea robusta y escalable. Esta misma base de datos, o
-- una versión mejorada de la misma, puede ser utilizada para 
-- otros proyectos interesantes.

-- Create Students Table: Esta tabla contiene los datos de los estudiantes
-- como su nombre y registro universitario. 
-- Create a new table called 'Students' in schema 'University'
CREATE TABLE university.students
(
    student_id          INT NOT NULL AUTO_INCREMENT, -- primary key column
    student_password    VARCHAR(45),
    ru                  INT NOT NULL,
    ci                  INT NOT NULL,
    first_name          VARCHAR(45) NOT NULL,
    last_name           VARCHAR(45) NOT NULL,
    PRIMARY KEY ( student_id ),
    UNIQUE KEY ( ru ),
    UNIQUE KEY ( ci )
);
--      DESC students;
--      CREATE UNIQUE INDEX ci ON university.students(ci);
--      CREATE UNIQUE INDEX ru ON university.students(ru);

-- Create SUBJECTS Table: Esta tabla contiene los datos de las materias de la carrera
-- como su nombre y código. Lo más importante es que se relaciona consigo misma
-- debido a que cada materia tiene otra materia como prerequisito.
-- Create a new table called 'subjects' in schema 'University'
CREATE TABLE university.subjects
(
    subject_id          INT NOT NULL AUTO_INCREMENT, -- primary key column
    code                VARCHAR(45) NOT NULL,
    subject_name        VARCHAR(45) NOT NULL,
    descrip             TINYTEXT,
    semester            INT NOT NULL,
    required_subject    INT NOT NULL,
    PRIMARY KEY ( subject_id ),
    CONSTRAINT FOREIGN KEY ( required_subject ) REFERENCES university.subjects(subject_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
--      DESC subjects;
    
-- Create professor Table: Esta tabla contiene los datos de los docentes
-- como su nombre y cédula de identidad. 
-- Create a new table called 'professors' in db 'university'
CREATE TABLE university.professors
(
    professor_id        INT NOT NULL AUTO_INCREMENT, -- primary key 
    ci                  INT NOT NULL,
    first_name          VARCHAR(45) NOT NULL,
    last_name           VARCHAR(45) NOT NULL,
    PRIMARY KEY ( professor_id )
); 
--      DESC professors;

-- Create classrooms Table: Esta tabla contiene los datos de las aulas
-- como su capacidad y código 
-- Create a new table called 'classrooms' in db 'university'
CREATE TABLE university.classrooms
(
    classroom_id        INT NOT NULL AUTO_INCREMENT, -- primary key
    classroom_code      INT NOT NULL,
    capacity            INT NOT NULL,
    PRIMARY KEY ( classroom_id ),
    UNIQUE KEY ( classroom_code )
);
--      DESC classrooms;

-- Create schedule_blocks Table: Esta tabla contiene los datos de los bloques de horarios
-- en que está dividida la semana de la universidad. Cada bloque tiene un día y un intervalo de hora
-- Para días de la semana: 1 = lUNES, 2 = MARTES,...
-- Create a new table called 'schedule_blocks' in DB 'university'
CREATE TABLE university.schedule_blocks
(
    schedule_block_id   INT NOT NULL AUTO_INCREMENT, -- primary key 
    weekly_day          INT NOT NULL, 
    start_time          TIME NOT NULL, 
    end_time            TIME NOT NULL,
    PRIMARY KEY ( schedule_block_id )
);
--      DESC schedule_blocks;

-- Create members Table: Esta tabla contiene los datos de las inscripciones de 
-- estudiantes en las distintas materias
-- Create a new table called 'members' in schema 'University'
CREATE TABLE university.members
(
    student_id          INT NOT NULL, 
    subject_id          INT NOT NULL,
    score               INT,
    login_date          DATE,
    PRIMARY KEY ( student_id, subject_id ),
    CONSTRAINT FOREIGN KEY ( student_id ) REFERENCES university.students(student_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY ( subject_id ) REFERENCES university.subjects(subject_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
--      DESC members;

-- Create schedule Table: Esta tabla contiene los datos de los horarios, docentes
-- y aulas de cada materia.
-- Create a new table called 'schedule' in schema 'University'
CREATE TABLE university.schedule
( 
    subject_id          INT NOT NULL,
    schedule_block_id   INT NOT NULL,
    professor_id        INT NOT NULL,
    classroom_id        INT NOT NULL,
    PRIMARY KEY ( subject_id, schedule_block_id, professor_id, classroom_id ),
    CONSTRAINT FOREIGN KEY ( subject_id ) REFERENCES university.subjects(subject_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY ( schedule_block_id ) REFERENCES university.schedule_blocks(schedule_block_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY ( professor_id ) REFERENCES university.professors(professor_id)
        ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT FOREIGN KEY ( classroom_id ) REFERENCES university.classrooms(classroom_id)
        ON DELETE CASCADE ON UPDATE CASCADE
);
--      DESC schedule;
--      SHOW TABLES;