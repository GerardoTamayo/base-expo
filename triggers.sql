DROP DATABASE if EXISTS quickstock;
CREATE DATABASE quickstock;

USE quickstock;

CREATE TABLE tb_productos (
  id_producto INT AUTO_INCREMENT PRIMARY KEY,
  nombre_producto VARCHAR(50) NOT NULL,
  fecha_vencimiento DATETIME NOT NULL,
  precio_compra DECIMAL(10,2) NOT NULL,
  precio_venta DECIMAL(10,2) NOT NULL,
  descripcion VARCHAR(100)NOT NULL,
  id_tipo_presentacion INT NOT NULL,
  id_categoria INT NOT NULL,
  id_marca INT NOT NULL,
  id_usuario INT NOT NULL
);

CREATE TABLE tb_categorias (
  id_categoria INT AUTO_INCREMENT PRIMARY KEY,	
  nombre_categoria VARCHAR(25) NOT NULL
);

CREATE TABLE tipo_presentaciones (
  id_tipo_presentacion INT AUTO_INCREMENT PRIMARY KEY,
  tipo_presentacion VARCHAR(25) NOT NULL
);

CREATE TABLE tb_vendedores (
  id_vendedor INT AUTO_INCREMENT PRIMARY KEY,
  nombre_vendedor VARCHAR(50) NOT NULL,
  apellido_vendedor VARCHAR(50) NOT NULL,
  telefono_vendedor VARCHAR(10) NOT NULL,
  correo_vendedor VARCHAR(100) UNIQUE NOT NULL
);

CREATE TABLE tb_marcas (
  id_marca INT AUTO_INCREMENT PRIMARY KEY,
  nombre_marca VARCHAR(25) NOT NULL,
  imagen VARCHAR(25)
);

CREATE TABLE tb_usuarios (
  id_usuario INT AUTO_INCREMENT PRIMARY KEY,
  nombre_usuario VARCHAR(50) NOT NULL,
  apellido_usuario VARCHAR(50) NOT NULL,
  usuario VARCHAR(25) NOT NULL,
  clave_usuario VARCHAR(25) NOT NULL,
  correo_usuario VARCHAR(100) UNIQUE NOT NULL,
  id_tipo INT NOT NULL
);

CREATE TABLE tb_tipousuarios (
  id_tipo INT AUTO_INCREMENT PRIMARY KEY,
  tipo_usuario VARCHAR(25) NOT NULL
);

CREATE TABLE tb_compras (
  id_compra INT AUTO_INCREMENT PRIMARY KEY,
  fecha_compra DATETIME NOT NULL,
  numero_correlativo INT NOT NULL,
  cantidad INT NOT NULL,
  estado_compra ENUM('Cancelada','No cancelada') NOT NULL,
  id_vendedor INT NOT NULL,
  id_producto INT NOT NULL
);

CREATE TABLE tb_ventas (
  id_venta INT AUTO_INCREMENT PRIMARY KEY,
  fecha_venta DATETIME NOT NULL,
  observacion_venta VARCHAR(100),
  cantidad INT NOT NULL,
  id_cliente INT NOT NULL,
  id_producto INT NOT NULL
);

CREATE TABLE tb_inventarios (
  id_inventario INT AUTO_INCREMENT PRIMARY KEY,
  id_producto INT NOT NULL,
  existencias_producto INT NOT NULL,
  id_venta INT NOT NULL,
  id_compra INT NOT NULL
);

CREATE TABLE tb_clientes (
  id_cliente INT AUTO_INCREMENT PRIMARY KEY,
  nombre_cliente VARCHAR(50) NOT NULL,
  apellido_cliente VARCHAR(50) NOT NULL,
  telefono_cliente VARCHAR(10),
  correo_cliente VARCHAR(100) UNIQUE,
  dui_cliente VARCHAR(100) UNIQUE,
  direccion_cliente VARCHAR(100)
);

ALTER TABLE tb_productos ADD CONSTRAINT fk_id_categoria FOREIGN KEY (id_categoria) REFERENCES tb_categorias (id_categoria);

ALTER TABLE tb_productos ADD CONSTRAINT fk_id_tipo_presentacion FOREIGN KEY (id_tipo_presentacion) REFERENCES tipo_presentaciones (id_tipo_presentacion);

ALTER TABLE tb_productos ADD CONSTRAINT fk_id_marca FOREIGN KEY (id_marca) REFERENCES tb_marcas (id_marca);

ALTER TABLE tb_usuarios ADD CONSTRAINT fk_id_tipo FOREIGN KEY (id_tipo) REFERENCES tb_tipousuarios (id_tipo);

ALTER TABLE tb_compras ADD CONSTRAINT fk_id_vendedor FOREIGN KEY (id_vendedor) REFERENCES tb_vendedores (id_vendedor);

ALTER TABLE tb_inventarios ADD CONSTRAINT fk_id_producto FOREIGN KEY (id_producto) REFERENCES tb_productos (id_producto);

ALTER TABLE tb_productos ADD CONSTRAINT fk_id_usuario FOREIGN KEY (id_usuario) REFERENCES tb_usuarios (id_usuario);

ALTER TABLE tb_ventas ADD CONSTRAINT fk_id_cliente FOREIGN KEY (id_cliente) REFERENCES tb_clientes (id_cliente);

ALTER TABLE tb_compras ADD FOREIGN KEY (id_producto) REFERENCES tb_productos (id_producto);

ALTER TABLE tb_ventas ADD FOREIGN KEY (id_producto) REFERENCES tb_productos (id_producto);

ALTER TABLE tb_inventarios ADD FOREIGN KEY (id_compra) REFERENCES tb_compras (id_compra);

ALTER TABLE tb_inventarios ADD FOREIGN KEY (id_venta) REFERENCES tb_ventas (id_venta);

DELIMITER $$

CREATE TRIGGER actualizar_inventario_venta
AFTER INSERT ON tb_ventas
FOR EACH ROW BEGIN
    UPDATE tb_inventarios
    SET existencias_producto = existencias_producto - NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END $$

CREATE TRIGGER actualizar_inventario_compra
AFTER INSERT ON tb_compras
FOR EACH ROW BEGIN
    UPDATE tb_inventarios
    SET existencias_producto = existencias_producto + NEW.cantidad
    WHERE id_producto = NEW.id_producto;
END $$

DELIMITER ;