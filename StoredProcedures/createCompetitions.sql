DROP PROCEDURE createTestResults4AllPersons;
DELIMITER / / CREATE PROCEDURE createTestResults4AllPersons(IN in_competition INT) BEGIN
DECLARE l_pid INT DEFAULT 0;
DECLARE l_last_row_fetched INT DEFAULT 0;
DECLARE cursor_pid CURSOR FOR
SELECT pid
FROM person
WHERE 1;
DECLARE CONTINUE HANDLER FOR NOT FOUND
SET l_last_row_fetched = 1;
SET l_last_row_fetched = 0;
OPEN cursor_pid;
person_cursor: LOOP FETCH cursor_pid INTO l_pid;
IF l_last_row_fetched = 1 THEN LEAVE person_cursor;
END IF;
CALL createTestResults(l_pid, in_competition);
END LOOP person_cursor;
CLOSE cursor_pid;
END / / DELIMITER;