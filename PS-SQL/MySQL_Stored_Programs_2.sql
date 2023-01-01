-- Using Non-SELECT SQL in Stored Programs
-- 1
DROP PROCEDURE IF EXISTS simple_sqls;
DELIMITER $$

CREATE PROCEDURE simple_sqls()
BEGIN
    DECLARE i INT DEFAULT 1;
    -- https://dev.mysql.com/doc/refman/8.0/en/innodb-autocommit-commit-rollback.html
    SET autocommit=0;

    DROP TABLE IF EXISTS test_table;
    CREATE TABLE test_table(
        id INT PRIMARY KEY,
        some_data VARCHAR(30)
    ) ENGINE=innodb;

    WHILE (i <= 10) DO
        INSERT INTO test_table
            VALUES(i, CONCAT("record ", i));
        SET i = i+1;
    END WHILE;

    SET i = 5;
    UPDATE test_table
        SET some_data = CONCAT("I updated row: ", i)
        WHERE id=i;

    DELETE FROM test_table WHERE id>i;
END $$
DELIMITER ;

CALL simple_sqls();
SELECT * FROM test_table WHERE 1;

-- 2
DROP PROCEDURE IF EXISTS get_customer_details;

DELIMITER $$
CREATE PROCEDURE get_customer_details(in_costomer_id INT)
BEGIN
    DECLARE l_customer_name VARCHAR(30);
    DECLARE l_contact_surname VARCHAR(30);
    DECLARE l_contact_firstname VARCHAR(30);

    SELECT customerName, contactLastName, contactFirstName
    INTO l_customer_name, l_contact_surname, l_contact_firstname
    FROM customers
    WHERE customerNumber=in_costomer_id;

    SET @cn = l_customer_name;
    SET @cln = l_contact_surname;
    SET @cfn = l_contact_firstname;
END $$

DELIMITER ;

CALL get_customer_details(112);
SELECT @cn, @cln, @cfn;