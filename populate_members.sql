INSERT INTO members 
( -- columns to insert data into
    student_id, subject_id, score, login_date --  'YYYY-MM-DD'
)
VALUES
( 2, 2, 0, "2019-08-11" ),
( 3, 4, 0, "2019-07-12" ),
( 4, 5, 0, "2019-08-10" ),
( 5, 8, 0, "2019-07-21" ),
( 6, 11, 0, "2019-08-09" );

--  SELECT * FROM members;
--  DELETE FROM members WHERE student_id=2;
--  DELETE FROM members WHERE student_id>2;
--  ALTER TABLE members AUTO_INCREMENT = 2;
--  UPDATE members SET score = 100 WHERE student_id=3;

SELECT students.first_name, students.last_name, subjects.code, subjects.subject_name 
FROM students, subjects, members
WHERE members.subject_id = subjects.subject_id
AND     members.student_id = students.student_id;