INSERT INTO schedule
( -- columns to insert data into
    subject_id, schedule_block_id, professor_id, classroom_id
)
VALUES
( 4, 1, 6, 10),
( 5, 7, 3, 12),
( 6, 3, 4, 9),
( 7, 4, 5, 4),
( 8, 2, 4, 13),
( 9, 8, 1, 10);

--  SELECT * FROM schedule;
--  DELETE FROM schedule WHERE subject_id=2;
--  DELETE FROM schedule WHERE subject_id>2;
--  ALTER TABLE schedule AUTO_INCREMENT = 2;
--  UPDATE schedule SET classroom_id = 12 WHERE subject_id=3;

SELECT subjects.code, subjects.subject_name, schedule_blocks.start_time, schedule_blocks.end_time 
FROM subjects, schedule, schedule_blocks
WHERE schedule.subject_id = subjects.subject_id
AND   schedule.schedule_block_id = schedule_blocks.schedule_block_id;