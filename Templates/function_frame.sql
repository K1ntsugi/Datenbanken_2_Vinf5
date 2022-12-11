DROP FUNCTION foo;

Delimiter $$

CREATE FUNCTION foo(input_param INT) RETURNS VARCHAR(20)
-- NO SQL ?
-- DETERMINISITC or NOT ?
Begin

END $$

Delimiter ;