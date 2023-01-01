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

-- Stored Functions Übung 2
-- https://www.mysqltutorial.org/mysql-stored-function/
DELIMITER $$

DROP FUNCTION if exists CustomerLEvel;
CREATE FUNCTION CustomerLevel(
	credit DECIMAL(10,2)
)
RETURNS VARCHAR(20)
DETERMINISTIC
BEGIN
    DECLARE customerLevel VARCHAR(20);

    IF credit > 50000 THEN
		SET customerLevel = 'PLATINUM';
    ELSEIF (credit >= 50000 AND
			credit <= 10000) THEN
        SET customerLevel = 'GOLD';
    ELSEIF credit < 10000 THEN
        SET customerLevel = 'SILVER';
    END IF;
	-- return the customer level
	RETURN (customerLevel);
END$$
DELIMITER ;

/*
View all stored functions:
SHOW FUNCTION STATUS
WHERE db = 'classicmodels';
 */

 /*
SELECT customerName, CustomerLevel(creditLimit)
FROM customers;
-> Funktioniert
Sobald ich einfüge:
WHERER customers
-> Funktioniert nicht => WHY?
  */

-- Call Stored Function in Stored Procedure
-- https://www.mysqltutorial.org/mysql-select-into-variable/
DROP PROCEDURE if exists GetCustomerLevel;
DELIMITER $$

CREATE PROCEDURE GetCustomerLevel(
    IN  customerNo INT,
    OUT customerLevel VARCHAR(20)
)
BEGIN

	DECLARE credit DEC(10,2) DEFAULT 0;

    -- get credit limit of a customer
    SELECT
		creditLimit
	INTO credit
    FROM customers
    WHERE
		customerNumber = customerNo;

    -- call the function
    SET customerLevel = CustomerLevel(credit);
END$$

DELIMITER ;