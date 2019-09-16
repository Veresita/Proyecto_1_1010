INSERT INTO professors
( -- columns to insert data into
    ci, first_name, last_name
)
VALUES
( 8452045, "Teodoro", "Busch" ),
( 7442017, "Gonzalo", "Vargas" ),
( 6432146, "Teresa", "Amúsquivar" ),
( 5421048, "Fernando", "Vásquez" ),
( 4422043, "Sonia", "Cordero" ),
( 3132041, "Rafael", "Valencia" );

--  SELECT * FROM professors;
--  DELETE FROM professors WHERE professor_id=2;
--  DELETE FROM professors WHERE professor_id>2;
--  ALTER TABLE professors AUTO_INCREMENT = 2;
--  UPDATE professors SET first_name = "Casiano" WHERE professor_id=3;