INSERT INTO classrooms
( -- columns to insert data into
    classroom_code, capacity
)
VALUES
( 301, 10),
( 302, 20),
( 303, 30),
( 304, 120),
( 305, 40),
( 306, 50),
( 307, 40),
( 308, 40),
( 10, 120),
( 11, 140),
( 12, 80),
( 13, 90),
( 14, 120),
( 21, 140),
( 22, 80),
( 23, 90);

--  SELECT * FROM classrooms;
--  DELETE FROM classrooms WHERE classroom_id=2;
--  DELETE FROM classrooms WHERE classroom_id>2;
--  ALTER TABLE classrooms AUTO_INCREMENT = 2;
--  UPDATE classrooms SET capacity = "Casiano" WHERE classroom_id=3;