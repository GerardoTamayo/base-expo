-- procedimiento para cambiar estado al usuario

DELIMITER $$

CREATE PROCEDURE cambiar_estado_usuario(IN usuario_id INT)
BEGIN
    DECLARE usuario_estado BOOLEAN;

    -- Obtener el estado actual del usuario
    SELECT estado_usuario INTO usuario_estado
    FROM tb_usuarios
    WHERE id_usuario = usuario_id;

    -- Actualizar el estado del usuario
    IF usuario_estado = 1 THEN
        UPDATE tb_usuarios
        SET estado_usuario = 0
        WHERE id_usuario = usuario_id;
    ELSE
        UPDATE tb_usuarios
        SET estado_usuario = 1
        WHERE id_usuario = usuario_id;
    END IF;
END $$

DELIMITER $$

-- procedimiento para sumar a las existencias

DELIMITER $$
CREATE PROCEDURE insertar_orden_validado(
    IN p_id_compra INT,
    IN p_cantidad_comprada INT,
    IN p_id_producto INT, 
    IN p_precio DECIMAL(10, 2)
)
BEGIN
    DECLARE mensaje VARCHAR(255);

    -- Insertar el detalle de la compra
    INSERT INTO tb_detalle_compras (id_compra, cantidad_compra, precio_compra, id_producto)
    VALUES (p_id_compra, p_cantidad_comprada, p_precio , p_id_producto); -- precio_compra se puede ajustar según sea necesario
    SET mensaje = 'Producto agregado a la compra correctamente.';

    -- Ajustar las existencias en la tabla tb_productos
    UPDATE tb_productos
    SET existencias_producto = existencias_producto + p_cantidad_comprada
    WHERE id_producto = p_id_producto;

    SELECT mensaje;
END $$
DELIMITER ;

-- CALL insertar_orden_validado(18, 30, 1);

-- actualizar cantidad

DELIMITER $$

DROP PROCEDURE IF EXISTS actualizar_detalle_compra;
CREATE PROCEDURE actualizar_detalle_compra(
    IN p_id_compra INT,
    IN p_id_detalle_compra INT,
    IN p_nueva_cantidad INT,
    IN p_id_producto INT,
    IN p_precio DECIMAL(10, 2)
)
BEGIN
    DECLARE p_cantidad_previa INT;
    DECLARE diferencia INT;
    DECLARE mensaje VARCHAR(255);

    -- Obtener la cantidad previa del detalle de compra
    SELECT cantidad_compra INTO p_cantidad_previa
    FROM tb_detalle_compras
    WHERE id_detalle_compra = p_id_detalle_compra
    AND id_compra = p_id_compra
    LIMIT 1;

    -- Calcular la diferencia
    SET diferencia = p_nueva_cantidad - p_cantidad_previa;

    -- Actualizar la cantidad comprada en tb_detalle_compras
    UPDATE tb_detalle_compras
    SET cantidad_compra = p_nueva_cantidad, precio_compra = p_precio
    WHERE id_detalle_compra = p_id_detalle_compra
    AND id_compra = p_id_compra;

    -- Ajustar las existencias en la tabla tb_productos
    UPDATE tb_productos
    SET existencias_producto = existencias_producto + diferencia
    WHERE id_producto = p_id_producto;

    SET mensaje = 'Detalle de compra actualizado correctamente.';
    SELECT mensaje;
END $$

DELIMITER ;

/*CALL actualizar_detalle_compra(3, 10, 20, 5, 15.50);*/

-- procedimiento para eliminar detalle compra

DELIMITER $$

DROP PROCEDURE IF EXISTS eliminar_detalle_compra;
CREATE PROCEDURE eliminar_detalle_compra(
    IN p_id_detalle_compra INT,
    IN p_id_compra INT
)
BEGIN
    DECLARE p_cantidad_previa INT;
    DECLARE p_id_producto INT;

    -- Obtener la cantidad previa y el id_producto del detalle de compra a eliminar
    SELECT dc.cantidad_compra, dc.id_producto INTO p_cantidad_previa, p_id_producto
    FROM tb_detalle_compras dc
    WHERE dc.id_detalle_compra = p_id_detalle_compra
      AND dc.id_compra = p_id_compra
    LIMIT 1;

    -- Ajustar las existencias en la tabla tb_productos
    UPDATE tb_productos
    SET existencias_producto = existencias_producto - p_cantidad_previa
    WHERE id_producto = p_id_producto;

    -- Eliminar el detalle de la compra
    DELETE FROM tb_detalle_compras
    WHERE id_detalle_compra = p_id_detalle_compra
      AND id_compra = p_id_compra;

    -- Mensaje de confirmación
    SELECT CONCAT('El detalle de la compra con ID ', p_id_detalle_compra, ' ha sido eliminado y ', p_cantidad_previa, ' unidades han sido devueltas al inventario.') AS mensaje;
END $$

DELIMITER ;

/*CALL eliminar_detalle_compra(10, 5);*/

-- procedimiento para agregar productos a venta

DELIMITER $$

CREATE PROCEDURE insertar_detalle_venta(
    IN p_id_venta INT,
    IN p_cantidad_venta INT,
    IN p_id_producto INT,
    IN p_precio DECIMAL(10, 2)
)
BEGIN
    DECLARE mensaje VARCHAR(255);
    DECLARE existencias_actuales INT;

    -- Obtener las existencias actuales del producto
    SELECT existencias_producto INTO existencias_actuales
    FROM tb_productos
    WHERE id_producto = p_id_producto
    LIMIT 1;

    -- Verificar si hay suficientes existencias para la venta
    IF p_cantidad_venta <= existencias_actuales THEN
        -- Insertar el detalle de la venta
        INSERT INTO tb_detalle_ventas (id_venta, cantidad_venta, precio_venta, id_producto)
        VALUES (p_id_venta, p_cantidad_venta, p_precio, p_id_producto);
        SET mensaje = 'Producto agregado a la venta correctamente.';

        -- Ajustar las existencias en la tabla tb_productos
        UPDATE tb_productos
        SET existencias_producto = existencias_producto - p_cantidad_venta
        WHERE id_producto = p_id_producto;
    ELSE
        SET mensaje = 'No hay suficientes existencias para completar la venta.';
    END IF;

    SELECT mensaje;
END $$

DELIMITER ;


-- CALL insertar_detalle_venta(1, 5, 3, 100.00);

-- procedimiento para actualizar un detalle venta

DELIMITER $$

CREATE PROCEDURE actualizar_detalle_venta(
    IN p_id_venta INT,
    IN p_id_detalle_venta INT,
    IN p_nueva_cantidad INT,
    IN p_id_producto INT,
    IN p_precio DECIMAL(10, 2)
)
BEGIN
    DECLARE p_cantidad_previa INT;
    DECLARE diferencia INT;
    DECLARE mensaje VARCHAR(255);
    DECLARE existencias_actuales INT;

    -- Obtener la cantidad previa del detalle de venta
    SELECT cantidad_venta INTO p_cantidad_previa
    FROM tb_detalle_ventas
    WHERE id_detalle_venta = p_id_detalle_venta
    AND id_venta = p_id_venta
    LIMIT 1;

    -- Calcular la diferencia
    SET diferencia = p_nueva_cantidad - p_cantidad_previa;

    -- Obtener las existencias actuales del producto
    SELECT existencias_producto INTO existencias_actuales
    FROM tb_productos
    WHERE id_producto = p_id_producto
    LIMIT 1;

    -- Verificar si hay suficientes existencias para la nueva cantidad
    IF diferencia <= existencias_actuales THEN
        -- Actualizar la cantidad vendida en tb_detalle_ventas
        UPDATE tb_detalle_ventas
        SET cantidad_venta = p_nueva_cantidad, precio_venta = p_precio
        WHERE id_detalle_venta = p_id_detalle_venta
        AND id_venta = p_id_venta;

        -- Ajustar las existencias en la tabla tb_productos
        UPDATE tb_productos
        SET existencias_producto = existencias_producto - diferencia
        WHERE id_producto = p_id_producto;

        SET mensaje = 'Detalle de venta actualizado correctamente.';
    ELSE
        SET mensaje = 'No hay suficientes existencias para la nueva cantidad.';
    END IF;

    SELECT mensaje;
END $$

DELIMITER ;

-- CALL actualizar_detalle_venta(1, 2, 10, 3, 150.00);

-- procedimiento para eliminar un detalle venta

DELIMITER $$
CREATE PROCEDURE eliminar_detalle_venta(
    IN p_id_detalle_venta INT,
    IN p_id_venta INT
)
BEGIN
    DECLARE p_cantidad_previa INT;
    DECLARE p_id_producto INT;

    -- Obtener la cantidad previa y el id_producto del detalle de venta a eliminar
    SELECT dv.cantidad_venta, dv.id_producto INTO p_cantidad_previa, p_id_producto
    FROM tb_detalle_ventas dv
    WHERE dv.id_detalle_venta = p_id_detalle_venta
      AND dv.id_venta = p_id_venta
    LIMIT 1;

    -- Ajustar las existencias en la tabla tb_productos
    UPDATE tb_productos
    SET existencias_producto = existencias_producto + p_cantidad_previa
    WHERE id_producto = p_id_producto;

    -- Eliminar el detalle de la venta
    DELETE FROM tb_detalle_ventas
    WHERE id_detalle_venta = p_id_detalle_venta
      AND id_venta = p_id_venta;

    -- Mensaje de confirmación
    SELECT CONCAT('El detalle de la venta con ID ', p_id_detalle_venta, ' ha sido eliminado y ', p_cantidad_previa, ' unidades han sido devueltas al inventario.') AS mensaje;
END $$

DELIMITER ;

-- CALL eliminar_detalle_venta(1, 2);