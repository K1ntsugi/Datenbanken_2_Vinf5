DROP PROCEDURE createTestResults;
DELIMITER / / CREATE PROCEDURE createTestResults(IN in_person INT, IN in_competition INT) BEGIN
DECLARE i INT DEFAULT 1;
DECLARE l_points INT DEFAULT 0;
WHILE (i <= 72) DO
SET l_points = FLOOR(7 + 4 * RAND());
INSERT INTO results_raw (person, competition, shotnumber, points)
VALUES (in_person, in_competition, i, l_points);
SET i = i + 1;
END WHILE;
END / / DELIMITER;
TRUNCATE results_raw;
CALL createTestResults(1, 1);
CALL createTestResults(1, 2);
CALL createTestResults(2, 1);
CALL createTestResults(2, 2);
CALL createTestResults(3, 1);
CALL createTestResults(3, 2);
select sum(points)
from results_raw
where person = 1
	and competition = 1;
select person,
	sum(points)
from results_raw
where competition = 1
group by person;
select competition,
	sum(points)
from results_raw
where person = 1
group by competition;
select person,
	competition,
	sum(points)
from results_raw
group by person,
	competition;
select person,
	competition,
	sum(points) as result
from results_raw
group by person,
	competition
having result > 599;
DROP PROCEDURE createTestResults4AllPersons;
DELIMITER / / CREATE PROCEDURE createTestResults4AllPersons(IN in_competition INT) BEGIN
DECLARE l_pid INT DEFAULT 0;
DECLARE cursor_pid CURSOR FOR
SELECT pid
FROM person
WHERE 1;
OPEN cursor_pid;
person_cursor: LOOP FETCH cursor_pid INTO l_pid;
CALL createTestResults(l_pid, in_competition);
END LOOP person_cursor;
CLOSE cursor_pid;
END / / DELIMITER;
TRUNCATE results_raw;
call createTestResults4AllPersons(1);
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
TRUNCATE results_raw;
call createTestResults4AllPersons(1);