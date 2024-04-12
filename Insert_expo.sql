-- Inserciones para la tabla tb_categorias
INSERT INTO tb_categorias (nombre_categoria) VALUES
('alimentos'),
('granos basicos'),
('Alimentos para animales'),
('productos de limpieza');

-- Inserciones para la tabla tipo_presentaciones
INSERT INTO tipo_presentaciones (tipo_presentacion) VALUES
('fardo'),
('caja'),
('quintal'),
('unidad');

-- Inserciones para la tabla tb_vendedores
INSERT INTO tb_vendedores (nombre_vendedor, apellido_vendedor, telefono_vendedor, correo_vendedor) VALUES
('Juan', 'Pérez', '1234567890', 'juanperez@example.com'),
('María', 'González', '0987654321', 'mariagonzalez@example.com'),
('Pedro', 'López', '1112223333', 'pedrolopez@example.com'),
('Ana', 'Martínez', '4445556666', 'anamartinez@example.com'),
('Luis', 'Rodríguez', '7778889999', 'luisrodriguez@example.com');

-- Inserciones para la tabla tb_marcas
INSERT INTO tb_marcas (nombre_marca, imagen) VALUES
('Mercosal', 'mercosal.jpg'),
('Orisol', 'orisol.jpg'),
('Nestlé', 'nestle.jpg'),
('Bimbo', 'bimbo.jpg'),
('Unilevel', 'unilevel.jpg');

-- Inserciones para la tabla tb_tipousuarios
INSERT INTO tb_tipousuarios (tipo_usuario) VALUES
('Administrador'),
('bodeguero'),
('cajero');

-- Inserciones para la tabla tb_usuarios
INSERT INTO tb_usuarios (nombre_usuario, apellido_usuario, usuario, clave_usuario, correo_usuario, id_tipo) VALUES
('Admin', 'Admin', 'admin', 'admin123', 'admin@example.com', 1),
('Vendedor1', 'Vendedor', 'vendedor1', 'vendedor123', 'vendedor1@example.com', 2),
('Vendedor2', 'Vendedor', 'vendedor2', 'vendedor123', 'vendedor2@example.com', 2),
('Vendedor3', 'Vendedor', 'vendedor3', 'vendedor123', 'vendedor3@example.com', 2),
('Vendedor4', 'Vendedor', 'vendedor4', 'vendedor123', 'vendedor4@example.com', 2);

-- Inserciones para la tabla tb_clientes
INSERT INTO tb_clientes (nombre_cliente, apellido_cliente, telefono_cliente, correo_cliente, dui_cliente, direccion_cliente) VALUES
('Carlos', 'López', '2223334444', 'carloslopez@example.com', '0011223344', '123 Calle Principal'),
('María', 'Sánchez', '5556667777', 'mariasanchez@example.com', '1122334455', '456 Avenida Central'),
('José', 'García', '8889990000', 'josegarcia@example.com', '2233445566', '789 Carretera Secundaria'),
('Laura', 'Hernández', '1112223333', 'laurahernandez@example.com', '3344556677', '0123 Camino Privado'),
('Roberto', 'Martínez', '4445556666', 'robertomartinez@example.com', '4455667788', '789 Ruta Escondida');

-- Inserciones para la tabla tb_productos
INSERT INTO tb_productos (nombre_producto, fecha_vencimiento, precio_compra, precio_venta, descripcion, id_tipo_presentacion, id_categoria, id_marca, id_usuario) VALUES
('Televisor LED 50 pulgadas', '2024-05-30 00:00:00', 500.00, 700.00, 'Televisor Full HD con resolución 1080p', 1, 1, 4, 1),
('Camiseta deportiva', '2024-12-31 00:00:00', 20.00, 35.00, 'Camiseta Nike de tela transpirable', 1, 2, 2, 1),
('Arroz blanco', '2025-06-30 00:00:00', 10.00, 15.00, 'Arroz de grano largo, paquete de 1 kg', 2, 3, 3, 1),
('Sofá de tres plazas', '2024-10-15 00:00:00', 400.00, 600.00, 'Sofá tapizado en tela de alta calidad', 1, 4, 5, 1),
('Set de bloques de construcción', '2025-01-01 00:00:00', 25.00, 40.00, 'Set de bloques LEGO para construir', 1, 5, 5, 1);

-- Inserciones para la tabla tb_compras
INSERT INTO tb_compras (fecha_compra, numero_correlativo, estado_compra, id_vendedor) VALUES
('2024-04-01 10:00:00', 1001, 'No cancelada', 1),
('2024-04-03 11:30:00', 1002, 'No cancelada', 2),
('2024-04-05 09:45:00', 1003, 'Cancelada', 3),
('2024-04-07 14:20:00', 1004, 'No cancelada', 4),
('2024-04-09 08:15:00', 1005, 'No cancelada', 5);

-- Inserciones para la tabla tb_ventas
INSERT INTO tb_ventas (fecha_venta, observacion_venta, id_cliente) VALUES
('2024-04-02 15:00:00', 'Venta en efectivo', 1),
('2024-04-04 16:30:00', 'Venta con tarjeta de crédito', 2),
('2024-04-06 10:45:00', 'Venta en efectivo', 3),
('2024-04-08 12:20:00', 'Venta en efectivo', 4),
('2024-04-10 09:00:00', 'Venta con tarjeta de débito', 5);

-- Inserciones para la tabla tb_inventarios
INSERT INTO tb_inventarios (id_producto, existencias_producto) VALUES
(1, 50,1),
(2, 100,2),
(3, 200,1),
(4, 30,1),
(5, 50,2);

