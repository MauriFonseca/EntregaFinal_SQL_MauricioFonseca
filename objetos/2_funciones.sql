USE Libreria_petricor;

--Calculo ventas para un cliente particular
DELIMITER //
DROP FUNCTION IF EXISTS total_ventas_cliente;
CREATE FUNCTION total_ventas_cliente(cliente_id INT)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2);
    SELECT SUM(cantidad * precio)
    INTO total
    FROM ventas
    WHERE id_clientes = cliente_id;
    RETURN IFNULL(total, 0);
END //
DELIMITER ;

-- Query para usar funcion de ventas de clientes
SELECT 
    id_clientes, 
    nombre, 
    total_ventas_cliente(id_clientes) AS total_ventas
FROM clientes
WHERE id_clientes = 1;

-- Gastos totales del periodo
USE Libreria_petricor;
DELIMITER //
DROP FUNCTION IF EXISTS total_gastos;
CREATE FUNCTION total_gastos(fecha_inicio DATE, fecha_fin DATE)
RETURNS DECIMAL(10, 2)
DETERMINISTIC
BEGIN
    DECLARE total DECIMAL(10, 2) DEFAULT 0;
    SELECT SUM(alquiler_local + IFNULL(salario, 0))
    INTO total
    FROM gastos_empresariales
    WHERE fecha BETWEEN fecha_inicio AND fecha_fin;
    RETURN IFNULL(total, 0);
END//

DELIMITER ;

-- Calcular gastos totales en 2024
SELECT 
    total_gastos('2024-01-01', '2024-12-31') AS gastos_totales_2024;