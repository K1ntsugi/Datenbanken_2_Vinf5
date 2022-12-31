/*
Flow Control 1:
- IF-Statement:
    IF search_condition THEN statement_list
    [ELSEIF search_condition THEN statement_list] ...
    [ELSE statement_list]
    END IF
- CASE-Statement with Expression:
    CASE case_value
        WHEN when_value THEN statement_list
        [WHEN when_value THEN statement_list] ...
        [ELSE statement_list]
        END CASE
- CASE-Statement with Search Condition
    CASE
        WHEN search_condition THEN statement_list
        [WHEN search_condition THEN statement_list] …
        [ELSE statement_list]
        END CASE
 */
-- Stored Procedure Übung 1(Heym)
-- 1.1 - 1.2
DROP PROCEDURE if exists HelloWorld;

DELIMITER $$
CREATE PROCEDURE HelloWorld()
BEGIN
    SELECT 'Hello World';
END $$
DELIMITER ;

-- 1.3
SHOW PROCEDURE STATUS
    WHERE db = 'classicmodels';

-- 2
DROP PROCEDURE if exists my_sqrt;
DELIMITER $$
CREATE PROCEDURE my_sqrt(input INT)
Begin
    DECLARE output FLOAT;
    set output = sqrt(input);
    SELECT output;
END $$
DELIMITER ;

-- 3
DROP PROCEDURE if exists my_sqrt2;
DELIMITER $$
CREATE PROCEDURE my_sqrt2(IN input INT, OUT output FLOAT)
BEGIN
    set output = sqrt(input);
END $$
DELIMITER ;

CALL my_sqrt2(13, @outval);
SELECT @outval;

/*
Flow Control 2:
New Statements in this lecture:
- Iterate
- Leave
- Return
- Loop
- Repeat
- While
 */
-- Example 1: Iterate, Leave, Loop
DROP PROCEDURE if exists loopTest;
DELIMITER $$
CREATE PROCEDURE loopTest()
BEGIN
    DECLARE i INT;
    SET i = 0;
    loop1:
    LOOP
        SET i = i+1;
        IF i >= 10 THEN
            LEAVE loop1;
            /*
            - This statement is used to exit the flow control
              construct that has the given label.
            - If the label is for the outermost stored program-block(scope!), LEAVE exits the program.
            - LEAVE can be used within BEGIN ... END or loop
              constructs (LOOP, REPEAT, WHILE)
             */
        ELSEIF MOD(i,2)=0 THEN
            ITERATE loop1; -- ITERATE means “start the loop again.”
             -- ITERATE can appear only within LOOP, REPEAT,and WHILE statements
        END IF;
        SELECT CONCAT(i," is an odd number");
    END LOOP loop1;
END $$
DELIMITER ;

/*
RETURN-Statement: Siehe MySQL_Stores.Programs.sql -> isRich()
- The RETURN statement terminates execution of
  a stored function and returns the value expr to the
  function caller.
- There must be at least one RETURN statement in
  a stored function.
- There may be more than one if the function has
  multiple exit points.
- This statement is NOT USED in STORED PROCEDURES,
  triggers, or events. The LEAVE statement can be
  used to exit a stored program of those types.
 */

 /*
LOOP-Statement:
- LOOP implements a simple loop construct,
  enabling repeated execution of the statement list,
  which consists of one or more statements, each
  terminated by a semicolon (;) statement delimiter.
- The statements within the loop are repeated until
  the loop is terminated. Usually, this is
  accomplished with a LEAVE statement. Within a
  stored function, RETURN can also be used,
  which exits the function entirely.
- Neglecting to include a loop-termination
  statement results in an infinite loop.
- A LOOP statement can be labeled.
*/

-- Example 2: Repeat ~ Do-While-Loop
DROP PROCEDURE if exists testRepeat;

DELIMITER $$
CREATE PROCEDURE testRepeat(p1 INT)
BEGIN
    SET @x = 0;
    REPEAT
        SET @x = @x+1;
    UNTIL @x > p1 END REPEAT;
END $$
DELIMITER ;
CALL testRepeat(1000);
SELECT @x;
/*
- The statement list within a REPEAT statement is
  repeated until the search_condition expression is
  true.
- Thus, a REPEAT always enters the loop at least
  once.
- Statement_list consists of one or more
  statements, each terminated by a semicolon (;)
  statement delimiter.
- A REPEAT statement can be labeled.
*/

-- Example 3: While == Übung2
-- https://www.mysqltutorial.org/mysql-stored-procedure/mysql-while-loop/
DROP TABLE if exists calendars;
CREATE TABLE calendars(
    id INT AUTO_INCREMENT,
    fulldate DATE UNIQUE,
    day TINYINT NOT NULL,
    month TINYINT NOT NULL,
    quarter TINYINT NOT NULL,
    year INT NOT NULL,
    PRIMARY KEY(id)
);

DROP PROCEDURE if exists InsertCalendar;
DELIMITER $$

CREATE PROCEDURE InsertCalendar(dt DATE)
BEGIN
    INSERT INTO calendars(
        fulldate,
        day,
        month,
        quarter,
        year
    )
    VALUES(
        dt,
        EXTRACT(DAY FROM dt),
        EXTRACT(MONTH FROM dt),
        EXTRACT(QUARTER FROM dt),
        EXTRACT(YEAR FROM dt)
    );
END$$

DELIMITER ;


DROP PROCEDURE if exists LoadCalendars;

DELIMITER $$
CREATE PROCEDURE LoadCalendars(
    startDate Date,
    day INT
)
BEGIN
    DECLARE count INT DEFAULT 1;
    DECLARE dt DATE DEFAULT startDate;

    WHILE count <= day DO
        CALL InsertCalendar(dt);
        SET count = count+1;
        SET dt = DATE_ADD(dt, INTERVAL 1 day);
    END WHILE;

END $$
DELIMITER ;
CALL LoadCalendars('2022-01-01',31);
SELECT * FROM calendars WHERE 1;