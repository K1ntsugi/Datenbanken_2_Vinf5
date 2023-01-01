-- 1: Cursor boilerplate example
DROP PROCEDURE IF EXISTS curser_demo;
DELIMITER $$
CREATE PROCEDURE curser_demo(in_customer_id INT)
BEGIN
    DECLARE v_customer_id INT;
    DECLARE v_custmoer_name VARCHAR(30);

    DECLARE c1 CURSOR FOR
        SELECT in_customer_id, customerName
        FROM customers
        WHERE customerNumber = in_customer_id;

    /*
     Jetzt kann mit dem Cursor gearbeitet werden
     */
END $$

DELIMITER ;

-- 2: Fetching a single row with a cursor
DROP PROCEDURE IF EXISTS curser_demo_fetch_row;
DELIMITER $$

CREATE PROCEDURE curser_demo_fetch_row()
BEGIN
    DECLARE l_customer_name VARCHAR(30);
    DECLARE l_contact_surname VARCHAR(30);
    DECLARE l_contact_firstname VARCHAR(30);

    DECLARE cursor1 CURSOR FOR
        SELECT customerName, contactLastName, contactFirstName
        FROM customers;

    OPEN cursor1;
    FETCH cursor1 INTO l_customer_name,
        l_contact_surname,l_contact_firstname;
    CLOSE cursor1;

    SET @cn = l_customer_name;
    SET @cln = l_contact_surname;
    SET @cfn = l_contact_firstname;
END $$

DELIMITER ;

CAll curser_demo_fetch_row();
SELECT @cn, @cln, @cfn;

-- 3 Fetching an entrie result set using loops
DROP PROCEDURE IF EXISTS cursor_fetch_resultSet;
DELIMITER $$

CREATE PROCEDURE cursor_fetch_resultSet()
BEGIN
    DECLARE l_customer_name VARCHAR(30);
    DECLARE l_contact_surname VARCHAR(30);
    DECLARE l_contact_firstname VARCHAR(30);
    DECLARE l_lastRowFetched INT;

    DECLARE cursor1 CURSOR FOR
        SELECT customerName, contactLastName, contactFirstName
        FROM customers;

    DECLARE CONTINUE HANDLER FOR NOT FOUND SET l_lastRowFetched = 1;

    SET l_lastRowFetched = 0;

    OPEN cursor1;

    cursor_loop :
    LOOP
        FETCH cursor1 INTO l_customer_name,
            l_contact_surname,l_contact_firstname;

        IF l_lastRowFetched = 1 THEN
            LEAVE cursor_loop;
        END IF;

         SELECT l_customer_name, l_contact_surname, l_contact_firstname;
    END LOOP;

    CLOSE cursor1;
END $$
DELIMITER ;

CALL cursor_fetch_resultSet();