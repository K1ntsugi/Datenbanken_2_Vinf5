DROP PROCEDURE if exists showCustomers;

DELIMITER $$
CREATE PROCEDURE showCustomers()
BEGIN
    SELECT * FROM customers WHERE 1;
END $$
DELIMITER ;
/***********************************************/