/*
Database: Classic models
Source: https://www.mysqltutorial.org/mysql-sample-database.aspx
*/

-- Testing a basic Stored Procedure
USE classicmodels;
DROP PROCEDURE if exists showCustomers;
DELIMITER $$
CREATE PROCEDURE showCustomers()
BEGIN
    SELECT * FROM customers WHERE 1;
END $$
DELIMITER ;

-- Testing a basic stored Function
DROP FUNCTION if exists isRich;

DELIMITER $$
CREATE FUNCTION isRich(credit INT) returns bool
    DETERMINISTIC
BEGIN
    IF(credit >= 200000) THEN
        return true;
    ELSE
        return false;
    END IF;
END $$
DELIMITER ;