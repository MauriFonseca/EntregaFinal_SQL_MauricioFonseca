--Trigger para ventas
USE Libreria_Petricor;
DELIMITER //

DROP TRIGGER IF EXISTS after_insert_ventas//

CREATE TRIGGER after_insert_ventas
AFTER INSERT ON ventas
FOR EACH ROW
BEGIN

    UPDATE inventario
    SET cantidad = cantidad - NEW.cantidad
    WHERE id_libros = NEW.id_libros
      AND id_deposito = (SELECT id_deposito
                         FROM libros
                         WHERE libros.id_libros = NEW.id_libros);
END//
DELIMITER ;

INSERT INTO ventas (id_clientes, id_libros, cantidad, precio)
VALUES (1, 2, 2, 34.00);



--Trigger para cuando un proveedor actualice un mail
CREATE TABLE IF NOT EXISTS historial_proveedores_email (
    id INT NOT NULL AUTO_INCREMENT PRIMARY KEY,
    id_proveedor INT NOT NULL,
    email_anterior VARCHAR(200) NOT NULL,
    email_nuevo VARCHAR(200) NOT NULL,
    fecha_cambio DATE DEFAULT (CURRENT_DATE),
    FOREIGN KEY (id_proveedor) REFERENCES proveedores(id_proveedores)
);
DELIMITER //

DROP TRIGGER IF EXISTS before_update_email_proveedor//

CREATE TRIGGER before_update_email_proveedor
BEFORE UPDATE ON proveedores
FOR EACH ROW
BEGIN
    IF OLD.email != NEW.email THEN
        INSERT INTO historial_proveedores_email (id_proveedor, email_anterior, email_nuevo, fecha_cambio)
        VALUES (OLD.id_proveedores, OLD.email, NEW.email, CURRENT_DATE);
    END IF;
END//

DELIMITER ;

UPDATE proveedores
SET email = 'nuevoemail@editorial.com'
WHERE id_proveedores = 1;