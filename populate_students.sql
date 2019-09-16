-- Insert rows into table 'students'
INSERT INTO students
( -- columns to insert data into
    student_password, ru, ci, first_name, last_name
)
VALUES
( 1, 1692766, 8462045, "Carlos", "Arena" ),
( 12, 1622263, 7462015, "Fernando", "Loroño" ),
( 123, 1891166, 6462145, "Sergio", "Ramírez" ),
( 1234, 2692766, 5461045, "Jorge", "Flores" ),
( 12345, 7694763, 4412045, "Ángel", "Arellano" ),
( 123456, 5292763, 3162045, "Paul", "Cardozo" );

--  SELECT * FROM students;
--  DELETE FROM students WHERE student_id=2;
--  DELETE FROM students WHERE student_id>2;
--  ALTER TABLE students AUTO_INCREMENT = 2;
--  UPDATE students SET first_name = "Carmelo" WHERE student_id=4;