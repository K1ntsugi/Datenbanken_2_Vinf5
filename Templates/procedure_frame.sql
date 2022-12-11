DROP PROCEDURE newProcedureName;

Delimiter $$

CREATE PROCEDURE newProcedureName(IN first_param INT, IN second_param INT, OUT result VARCHAR(20))

-- Falls das Programm nur eine Anweisung enthält kann Begin + End weggelassen werden
BEGIN
    --- Code goes here ---
END $$

Delimiter ;