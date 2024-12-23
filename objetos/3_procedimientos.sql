--Procedimiento para dar de alta a un empleado en la BS
DELIMITER //
DROP PROCEDURE IF EXISTS registrar_empleado;
CREATE PROCEDURE registrar_empleado(
    IN p_nombre VARCHAR(100),
    IN p_apellido VARCHAR(100),
    IN p_fecha_ingreso DATE,
    IN p_salario DECIMAL(10,2)
)
BEGIN
    DECLARE v_id_empleado INT;
    DECLARE v_fecha_actual DATE;
    DECLARE v_mensaje VARCHAR(200);

    IF p_fecha_ingreso IS NULL THEN
        SET v_fecha_actual = CURRENT_DATE;
    ELSE
        SET v_fecha_actual = p_fecha_ingreso;
    END IF;

    INSERT INTO empleados (
        nombre, 
        apellido, 
        fecha_ingreso, 
        salario
    ) VALUES (
        p_nombre, 
        p_apellido, 
        v_fecha_actual, 
        p_salario
    );

    SET v_id_empleado = LAST_INSERT_ID();

    INSERT INTO gastos_empresariales (
        fecha,
        id_empleados,
        alquiler_local,
        salario
    ) VALUES (
        v_fecha_actual,
        v_id_empleado,
        0,  
        p_salario
    );
    
--si se carga bien
    SET v_mensaje = CONCAT('Empleado ', p_nombre, ' ', p_apellido, ' registrado con ID: ', v_id_empleado);

    SELECT v_mensaje AS resultado;
END //
DELIMITER ;

CALL registrar_empleado('Mauricio', 'Fonseca', '2024-11-27', 55000.00);


-- Procedimiento par dar de alta un libro nuevo
DELIMITER //
DROP PROCEDURE IF EXISTS registrar_libro;
CREATE PROCEDURE registrar_libro(
    IN p_titulo VARCHAR(200),
    IN p_autor VARCHAR(100),
    IN p_id_categoria INT,
    IN p_id_proveedor INT,
    IN p_id_deposito INT,
    IN p_cantidad INT,
    IN p_precio DECIMAL(10,2)
)
BEGIN
    DECLARE v_id_libro INT;
    
    START TRANSACTION;

    INSERT INTO libros (
        titulo, 
        autor, 
        id_categoria, 
        id_proveedores, 
        id_deposito
    ) VALUES (
        p_titulo, 
        p_autor, 
        p_id_categoria, 
        p_id_proveedor, 
        p_id_deposito
    );
    

    SET v_id_libro = LAST_INSERT_ID();
    INSERT INTO inventario (
        id_libros, 
        id_deposito, 
        cantidad, 
        precio, 
        categoria
    ) VALUES (
        v_id_libro, 
        p_id_deposito, 
        p_cantidad, 
        p_precio, 
        (SELECT nombre_categoria FROM categorias WHERE id_categoria = p_id_categoria)
    );

    COMMIT;
    SELECT 'Libro registrado exitosamente' AS mensaje;
END //
DELIMITER ;

CALL registrar_libro(
    'Harry potter', 
    'JK Rowling', 
    1,
    2,  
    1,  
    50, 
    700 
);