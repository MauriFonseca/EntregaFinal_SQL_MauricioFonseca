-- Vista de estado de inventario
USE Libreria_petricor;

DROP VIEW IF EXISTS v_estado_inventario;
CREATE VIEW v_estado_inventario AS
SELECT 
    l.titulo,
    dl.pais,
    i.cantidad,
    i.precio,
    (i.cantidad * i.precio) as valor_inventario,
    CASE 
        WHEN i.cantidad < 20 THEN 'Crítico'
        WHEN i.cantidad < 50 THEN 'Bajo'
        ELSE 'Normal'
    END as nivel_stock
FROM inventario i
JOIN libros l ON i.id_libros = l.id_libros
JOIN deposito_logistica dl ON i.id_deposito = dl.id_deposito;

-- Vista de comportamiento de clientes
DROP VIEW IF EXISTS v_analisis_clientes;
CREATE VIEW v_analisis_clientes AS
SELECT 
    c.nombre,
    COUNT(v.id_venta) as numero_compras,
    SUM(v.cantidad) as libros_comprados,
    SUM(v.precio_IVA) as total_gastado,
    AVG(v.precio_IVA) as ticket_promedio,
    MAX(v.fecha) as ultima_compra
FROM clientes c
JOIN ventas v ON c.id_clientes = v.id_clientes
GROUP BY c.nombre;

-- Vista de Descuentos Activos
DROP VIEW IF EXISTS v_descuentos_activos;
CREATE VIEW v_descuentos_activos AS
SELECT 
    nombre,
    tipo,
    valor,
    fecha_inicio,
    fecha_fin,
    estado
FROM descuentos_promociones
WHERE estado = 'Activo';

-- Vista de Métodos de Pago Activos
DROP VIEW IF EXISTS v_metodos_pago_activos;
CREATE VIEW v_metodos_pago_activos AS
SELECT 
    nombre,
    descripcion,
    estado
FROM metodos_pago
WHERE estado = 'Activo';

-- Vista de Pedidos Recientes
DROP VIEW IF EXISTS v_pedidos_recentes;
CREATE VIEW v_pedidos_recentes AS
SELECT 
    p.id_pedido,
    cl.nombre as cliente_nombre,
    v.fecha as fecha_venta,
    p.direccion_envio,
    p.estado,
    p.fecha_pedido,
    p.fecha_entrega
FROM pedidos_online p
JOIN clientes cl ON p.id_cliente = cl.id_clientes
JOIN ventas v ON p.id_venta = v.id_venta
WHERE p.estado IN ('Pendiente', 'En Proceso', 'Enviado');
