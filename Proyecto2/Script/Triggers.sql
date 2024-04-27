DELIMITER //

-- 1) Triggers para la tabla TipoBien
CREATE TRIGGER BD1P2.TipoBien_INSERT
AFTER INSERT ON BD1P2.TipoBien
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoBien"', 'INSERT');
END //

CREATE TRIGGER BD1P2.TipoBien_UPDATE
AFTER UPDATE ON BD1P2.TipoBien
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoBien"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.TipoBien_DELETE
AFTER DELETE ON BD1P2.TipoBien
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoBien"', 'DELETE');
END //

-- 2) Triggers para la tabla TipoCliente
CREATE TRIGGER BD1P2.TipoCliente_INSERT
AFTER INSERT ON BD1P2.TipoCliente
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoCliente"', 'INSERT');
END //

CREATE TRIGGER BD1P2.TipoCliente_UPDATE
AFTER UPDATE ON BD1P2.TipoCliente
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoCliente"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.TipoCliente_DELETE
AFTER DELETE ON BD1P2.TipoCliente
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoCliente"', 'DELETE');
END //

-- 3) Triggers para la tabla TipoCuenta
CREATE TRIGGER BD1P2.TipoCuenta_INSERT
AFTER INSERT ON BD1P2.TipoCuenta
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoCuenta"', 'INSERT');
END //

CREATE TRIGGER BD1P2.TipoCuenta_UPDATE
AFTER UPDATE ON BD1P2.TipoCuenta
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoCuenta"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.TipoCuenta_DELETE
AFTER DELETE ON BD1P2.TipoCuenta
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoCuenta"', 'DELETE');
END //

-- 4) Triggers para la tabla TipoTransaccion
CREATE TRIGGER BD1P2.TipoTransaccion_INSERT
AFTER INSERT ON BD1P2.TipoTransaccion
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoTransaccion"', 'INSERT');
END //

CREATE TRIGGER BD1P2.TipoTransaccion_UPDATE
AFTER UPDATE ON BD1P2.TipoTransaccion
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoTransaccion"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.TipoTransaccion_DELETE
AFTER DELETE ON BD1P2.TipoTransaccion
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "TipoTransaccion"', 'DELETE');
END //

-- 5) Triggers para la tabla Bien
CREATE TRIGGER BD1P2.Bien_INSERT
AFTER INSERT ON BD1P2.Bien
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Bien"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Bien_UPDATE
AFTER UPDATE ON BD1P2.Bien
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Bien"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Bien_DELETE
AFTER DELETE ON BD1P2.Bien
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Bien"', 'DELETE');
END //

-- 6) Triggers para la tabla Cliente
CREATE TRIGGER BD1P2.Cliente_INSERT
AFTER INSERT ON BD1P2.Cliente
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Cliente"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Cliente_UPDATE
AFTER UPDATE ON BD1P2.Cliente
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Cliente"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Cliente_DELETE
AFTER DELETE ON BD1P2.Cliente
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Cliente"', 'DELETE');
END //

-- 7) Triggers para la tabla Telefono
CREATE TRIGGER BD1P2.Telefono_INSERT
AFTER INSERT ON BD1P2.Telefono
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Telefono"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Telefono_UPDATE
AFTER UPDATE ON BD1P2.Telefono
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Telefono"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Telefono_DELETE
AFTER DELETE ON BD1P2.Telefono
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Telefono"', 'DELETE');
END //

-- 8) Triggers para la tabla Correo
CREATE TRIGGER BD1P2.Correo_INSERT
AFTER INSERT ON BD1P2.Correo
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Correo"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Correo_UPDATE
AFTER UPDATE ON BD1P2.Correo
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Correo"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Correo_DELETE
AFTER DELETE ON BD1P2.Correo
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Correo"', 'DELETE');
END //

-- 9) Triggers para la tabla Cuenta
CREATE TRIGGER BD1P2.Cuenta_INSERT
AFTER INSERT ON BD1P2.Cuenta
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Cuenta"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Cuenta_UPDATE
AFTER UPDATE ON BD1P2.Cuenta
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Cuenta"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Cuenta_DELETE
AFTER DELETE ON BD1P2.Cuenta
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Cuenta"', 'DELETE');
END //

-- 10) Triggers para la tabla Compra
CREATE TRIGGER BD1P2.Compra_INSERT
AFTER INSERT ON BD1P2.Compra
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Compra"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Compra_UPDATE
AFTER UPDATE ON BD1P2.Compra
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Compra"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Compra_DELETE
AFTER DELETE ON BD1P2.Compra
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Compra"', 'DELETE');
END //

-- 11) Triggers para la tabla Debito
CREATE TRIGGER BD1P2.Debito_INSERT
AFTER INSERT ON BD1P2.Debito
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Debito"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Debito_UPDATE
AFTER UPDATE ON BD1P2.Debito
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Debito"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Debito_DELETE
AFTER DELETE ON BD1P2.Debito
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Debito"', 'DELETE');
END //

-- 12) Triggers para la tabla Deposito
CREATE TRIGGER BD1P2.Deposito_INSERT
AFTER INSERT ON BD1P2.Deposito
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Deposito"', 'INSERT');
END //

CREATE TRIGGER BD1P2.Deposito_UPDATE
AFTER UPDATE ON BD1P2.Deposito
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Deposito"', 'UPDATE');
END //

CREATE TRIGGER BD1P2.Deposito_DELETE
AFTER DELETE ON BD1P2.Deposito
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Deposito"', 'DELETE');
END //

-- 13) Triggers para la tabla Transaccion
CREATE TRIGGER BD1P2.Transaccion_INSERT
AFTER INSERT ON BD1P2.Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Transaccion"', 'INSERT');
END;
//

CREATE TRIGGER BD1P2.Transaccion_UPDATE
AFTER UPDATE ON BD1P2.Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Transaccion"', 'UPDATE');
END;
//

CREATE TRIGGER BD1P2.Transaccion_DELETE
AFTER DELETE ON BD1P2.Transaccion
FOR EACH ROW
BEGIN
    INSERT INTO BD1P2.Historial (fecha, descripcion, tipo)
    VALUES (NOW(), 'Se ha realizado una acción en la tabla "Transaccion"', 'DELETE');
END;
//

DELIMITER ;