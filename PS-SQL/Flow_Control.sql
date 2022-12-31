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

 */