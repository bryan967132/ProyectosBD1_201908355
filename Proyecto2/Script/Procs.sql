DROP PROCEDURE IF EXISTS BD1P2.registrarTipoCliente;     -- 1
DROP PROCEDURE IF EXISTS BD1P2.registrarTipoCuenta;      -- 2
DROP PROCEDURE IF EXISTS BD1P2.registrarTipoTransaccion; -- 3
DROP PROCEDURE IF EXISTS BD1P2.crearProductoServicio;    -- 4
DROP FUNCTION IF EXISTS BD1P2.procesarTelefonos;
DROP PROCEDURE IF EXISTS BD1P2.registrarTelefonos;
DROP FUNCTION IF EXISTS BD1P2.procesarCorreos;
DROP PROCEDURE IF EXISTS BD1P2.registrarCorreos;
DROP PROCEDURE IF EXISTS BD1P2.registrarCliente;         -- 5
DROP PROCEDURE IF EXISTS BD1P2.registrarCuenta;          -- 6
DROP PROCEDURE IF EXISTS BD1P2.realizarCompra;           -- 7
DROP PROCEDURE IF EXISTS BD1P2.realizarDeposito;         -- 8
DROP PROCEDURE IF EXISTS BD1P2.realizarDebito;           -- 9
DROP PROCEDURE IF EXISTS BD1P2.asignarTransaccion;       -- 10

DELIMITER //

-- registrarTipoCliente
CREATE PROCEDURE BD1P2.registrarTipoCliente(
    IN idTC          BIGINT,
    IN nombreTC      VARCHAR(40),
    IN descripcionTC VARCHAR(200)
) BEGIN
    DECLARE existeTipo BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeTipo FROM BD1P2.TipoCliente WHERE nombre = nombreTC;
    IF NOT existeTipo THEN
        IF LENGTH(nombreTC) > 0 AND LENGTH(descripcionTC) > 0 THEN
            IF descripcionTC REGEXP '^[[:alpha:][:punct:][:space:]]+$' THEN
                INSERT INTO BD1P2.TipoCliente (nombre, descripcion) VALUES
                (nombreTC, descripcionTC);
            ELSE
                SELECT '¡LA DESCRIPCIÓN DEL TIPO DE CLIENTE DEBE CONTENER SOLO LETRAS!' AS error_registrarTipoCliente;
                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡LA DESCRIPCIÓN DEL TIPO DE CLIENTE DEBE CONTENER SOLO LETRAS!';
            END IF;
        ELSE
            SELECT '¡EL NOMBRE Y LA DESCRIPCIÓN SON OBLIGATORIOS PARA CREAR UN NUEVO TIPO DE CLIENTE!' AS error_registrarTipoCliente;
        END IF;
    ELSE
        SELECT '¡EL NUEVO TIPO DE CLIENTE QUE INTENTA REGISTRAR YA EXISTE!' AS error_registrarTipoCliente;
    END IF;
END //
-- registrarTipoCuenta
CREATE PROCEDURE BD1P2.registrarTipoCuenta(
    IN idTC          BIGINT,
    IN nombreTC      VARCHAR(40),
    IN descripcionTC VARCHAR(200)
) BEGIN
    DECLARE existeTipo BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeTipo FROM BD1P2.TipoCuenta WHERE nombre = nombreTC;
    IF NOT existeTipo THEN
        IF LENGTH(nombreTC) > 0 AND LENGTH(descripcionTC) > 0 THEN
            INSERT INTO BD1P2.TipoCuenta (nombre, descripcion) VALUES
            (nombreTC, descripcionTC);
        ELSE
            SELECT '¡EL NOMBRE Y LA DESCRIPCIÓN SON OBLIGATORIOS PARA CREAR UN NUEVO TIPO DE CUENTA!' AS error_registrarTipoCuenta;
        END IF;
    ELSE
        SELECT '¡EL NUEVO TIPO DE CUENTA QUE INTENTA REGISTRAR YA EXISTE!' AS error_registrarTipoCuenta;
    END IF;
END //
-- registrarTipoTransaccion
CREATE PROCEDURE BD1P2.registrarTipoTransaccion(
    IN idTC          BIGINT,
    IN nombreTC      VARCHAR(40),
    IN descripcionTC VARCHAR(255)
) BEGIN
    DECLARE existeTipo BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeTipo FROM BD1P2.TipoTransaccion WHERE nombre = nombreTC;
    IF NOT existeTipo THEN
        IF LENGTH(nombreTC) > 0 AND LENGTH(descripcionTC) > 0 THEN
            INSERT INTO BD1P2.TipoTransaccion (nombre, descripcion) VALUES
            (nombreTC, descripcionTC);
        ELSE
            SELECT '¡EL NOMBRE Y LA DESCRIPCIÓN SON OBLIGATORIOS PARA CREAR UN NUEVO TIPO DE TRANSACCION!' AS error_registrarTipoTransaccion;
        END IF;
    ELSE
        SELECT '¡EL NUEVO TIPO DE TRANSACCIÓN QUE INTENTA REGISTRAR YA EXISTE!' AS error_registrarTipoTransaccion;
    END IF;
END //
-- crearProductoServicio
CREATE PROCEDURE BD1P2.crearProductoServicio(
    IN idPS          BIGINT,
    IN tipoPS        BIGINT,
    IN costoPS       FLOAT(2),
    IN descripcionPS VARCHAR(200)
) BEGIN
    DECLARE existeProductoServicio BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeProductoServicio FROM BD1P2.Bien WHERE id = idPS;
    IF NOT existeProductoServicio THEN
        IF tipoPS = 1 AND costoPS > 0 OR tipoPS = 2 AND costoPS = 0 THEN
            INSERT INTO BD1P2.Bien (id, costo, descripcion, tipobien_id) VALUES
            (idPS, costoPS, descripcionPS, tipoPS);
        ELSE IF tipoPS = 1 AND costoPS <= 0 THEN
            SELECT '¡COSTO INCORRECTO PARA UN SERVICIO!' AS error_crearProductoServicio;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡COSTO INCORRECTO PARA UN SERVICIO!';
        ELSE IF tipoPS = 2 AND costoPS != 0 THEN
            SELECT '¡COSTO INCORRECTO PARA UN PRODUCTO!' AS error_crearProductoServicio;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡COSTO INCORRECTO PARA UN PRODUCTO!';
        END IF;
        END IF;
        END IF;
    ELSE
        SELECT '¡EL NUEVO PRODUCTO/SERVICIO QUE INTENTA REGISTRAR YA EXISTE!' AS error_crearProductoServicio;
    END IF;
END //
-- procesarTelefonos
CREATE FUNCTION BD1P2.procesarTelefonos(
    cadena VARCHAR(255)
) RETURNS VARCHAR(255) DETERMINISTIC BEGIN
    DECLARE telefono            VARCHAR(12);
    DECLARE telefonosProcesados VARCHAR(255);
    DECLARE telefonoProcesado   VARCHAR(12);
    SET telefonosProcesados = '';
    WHILE CHAR_LENGTH(cadena) > 0 DO
        SET telefono = SUBSTRING_INDEX(cadena, '-', 1);
        IF CHAR_LENGTH(telefono) > 8 THEN
            SET telefonoProcesado = SUBSTRING(telefono, 4);
        ELSE
            SET telefonoProcesado = telefono;
        END IF;
        IF CHAR_LENGTH(telefonosProcesados) > 0 THEN
            SET telefonosProcesados = CONCAT(telefonosProcesados, '-', telefonoProcesado);
        ELSE
            SET telefonosProcesados = telefonoProcesado;
        END IF;
        SET cadena = SUBSTRING(cadena, CHAR_LENGTH(telefono) + 2);
    END WHILE;
    RETURN telefonosProcesados;
END //
-- registrarTelefonos
CREATE PROCEDURE BD1P2.registrarTelefonos(
    IN cadena    VARCHAR(255),
    IN clienteid BIGINT
) BEGIN
    DECLARE telefono            VARCHAR(12);
    DECLARE telefonosProcesados VARCHAR(255);
    DECLARE telefonoProcesado   VARCHAR(12);
    SET telefonosProcesados = '';
    WHILE CHAR_LENGTH(cadena) > 0 DO
        SET telefono = SUBSTRING_INDEX(cadena, '-', 1);
        INSERT INTO BD1P2.Telefono (numero, cliente_id) VALUE (telefono, clienteid);
        SET cadena = SUBSTRING(cadena, CHAR_LENGTH(telefono) + 2);
    END WHILE;
END //
-- procesarCorreos
CREATE FUNCTION BD1P2.procesarCorreos(
    cadena VARCHAR(255)
) RETURNS BOOLEAN DETERMINISTIC BEGIN
    DECLARE correo            VARCHAR(100);
    DECLARE correosProcesados VARCHAR(255);
    DECLARE correoValido      BOOLEAN;
    SET correosProcesados = '';
    WHILE CHAR_LENGTH(cadena) > 0 DO
        SET correo = SUBSTRING_INDEX(cadena, '|', 1);
        IF correo REGEXP '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Z|a-z]{2,}$' THEN
            SET correoValido = TRUE;
        ELSE
            SET correoValido = FALSE;
        END IF;
        IF NOT correoValido THEN
            RETURN FALSE;
        END IF;
        SET cadena = SUBSTRING(cadena, CHAR_LENGTH(correo) + 2);
    END WHILE;
    RETURN TRUE;
END //
-- registrarCorreos
CREATE PROCEDURE BD1P2.registrarCorreos(
    IN cadena VARCHAR(255),
    IN clienteid BIGINT
) BEGIN
    DECLARE correo            VARCHAR(100);
    DECLARE correosProcesados VARCHAR(255);
    DECLARE correoValido      BOOLEAN;
    SET correosProcesados = '';
    WHILE CHAR_LENGTH(cadena) > 0 DO
        SET correo = SUBSTRING_INDEX(cadena, '|', 1);
        INSERT INTO BD1P2.Correo (direccion, cliente_id) VALUE (correo, clienteid);
        SET cadena = SUBSTRING(cadena, CHAR_LENGTH(correo) + 2);
    END WHILE;
END //
-- registrarCliente
SET @clave = 'sisalebases1';
CREATE PROCEDURE BD1P2.registrarCliente(
    IN idC         BIGINT,
    IN nombreC     VARCHAR(40),
    IN apellidosC  VARCHAR(40),
    IN telefonosC  VARCHAR(255),
    IN correosC    VARCHAR(40),
    IN usuarioC    VARCHAR(40),
    IN contrasenaC VARCHAR(200),
    IN idtipoC     BIGINT
) BEGIN
    DECLARE existeUsuario        BOOLEAN DEFAULT FALSE;
    DECLARE correos_validos      BOOLEAN;
    DECLARE telefonos_procesados VARCHAR(255);
    DECLARE usuarioUsado         BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeUsuario FROM BD1P2.Cliente WHERE id = idC;
    IF NOT existeUsuario THEN
        IF nombreC REGEXP '^[[:alpha:][:space:]]+$' THEN
            IF apellidosC REGEXP '^[[:alpha:][:space:]]+$' THEN
                SELECT TRUE INTO usuarioUsado FROM BD1P2.Cliente WHERE usuario = usuarioC;
                IF NOT usuarioUsado THEN
                    SET correos_validos = BD1P2.procesarCorreos(correosC);
                    IF correos_validos THEN
                        SET telefonos_procesados = BD1P2.procesarTelefonos(telefonosC);
                        INSERT INTO BD1P2.Cliente (id, nombre, apellidos, usuario, contrasena, fechacreacion, tipocliente_id) VALUES
                        (idC, nombreC, apellidosC, usuarioC, HEX(AES_ENCRYPT(contrasenaC, @clave)), CURDATE(), idtipoC);
                        CALL BD1P2.registrarTelefonos(telefonosC, idC);
                        CALL BD1P2.registrarCorreos(correosC, idC);
                    ELSE
                        SELECT '¡El formato del o los correos del usuario que intenta registrar no son correctos!' AS error_registrarCliente;
                        -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El formato del o los correos del usuario que intenta registrar no son correctos!';
                    END IF;
                ELSE
                    SELECT '¡El nombre de usuario ya se encuentra en uso!' AS error_registrarCliente;
                    -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El nombre de usuario ya se encuentra en uso!';
                END IF;
            ELSE
                SELECT '¡El apellido del usuario que intenta registrar contiene caracteres extraños!' AS error_registrarCliente;
                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El apellido del usuario que intenta registrar contiene caracteres extraños!';
            END IF;
        ELSE
            SELECT '¡El nombre del usuario que intenta registrar contiene caracteres extraños!' AS error_registrarCliente;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El nombre del usuario que intenta registrar contiene caracteres extraños!';
        END IF;
    ELSE
        SELECT '¡El cliente que quiere registrar ya existe!' AS error_registrarCliente;
    END IF;
END //
-- registrarCuenta
CREATE PROCEDURE BD1P2.registrarCuenta(
    IN idC          BIGINT,
    IN montoApC     FLOAT(2),
    IN saldoC       FLOAT(2),
    IN descripcionC VARCHAR(255),
    IN fechaApC     VARCHAR(30),
    IN otrosdetC    VARCHAR(255),
    IN tipocuentaC  BIGINT,
    IN idclienteC   BIGINT
) BEGIN
    DECLARE existeCuenta BOOLEAN DEFAULT FALSE;
    DECLARE idtipocuenta BIGINT DEFAULT -1;
    DECLARE idcliente    BIGINT DEFAULT -1;
    DECLARE fechaNueva   DATETIME DEFAULT NOW();
    IF LENGTH(fechaApC) > 0 THEN
		SET fechaNueva = STR_TO_DATE(fechaApC, '%d/%m/%Y %H:%i:%s');
    END IF;
    SELECT TRUE INTO existeCuenta FROM BD1P2.Cuenta WHERE id = idC;
    IF NOT existeCuenta THEN
        IF montoApC > 0 THEN
            IF saldoC > 0 THEN
                if montoApC = saldoC THEN
                    SELECT id INTO idtipocuenta FROM BD1P2.TipoCuenta WHERE id = tipocuentaC;
                    IF idtipocuenta != -1 THEN
                        SELECT id INTO idcliente FROM BD1P2.Cliente WHERE id = idclienteC;
                        IF idcliente != -1 THEN
                            INSERT INTO BD1P2.Cuenta (id, monto_apertura, saldo, descripcion, fecha_apertura, otros_detalles, tipocuenta_id, cliente_id) VALUES
                            (idC, montoApC, saldoC, descripcionC, fechaNueva, otrosdetC, tipocuentaC, idclienteC);
                        ELSE
                            SELECT '¡Intenta vincular la cuenta a un cliente inexistente!' AS error_registrarCuenta;
                            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡Intenta vincular la cuenta a un cliente inexistente!';
                        END IF;
                    ELSE
                        SELECT '¡Intenta asignar un tipo inexistente a la cuenta!' AS error_registrarCuenta;
                        -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡Intenta asignar un tipo inexistente a la cuenta!';
                    END IF;
                ELSE
                    SELECT '¡El monto de apertura y el saldo de la cuenta deben coincidir para crearla!' AS error_registrarCuenta;
                END IF;
            ELSE
                SELECT '¡El saldo para la nueva cuenta debe ser una cantidad positiva!' AS error_registrarCuenta;
                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El saldo para la nueva cuenta debe ser una cantidad positiva!';
            END IF;
        ELSE
            SELECT '¡El monto de apertura para la nueva cuenta debe ser una cantidad positiva!' AS error_registrarCuenta;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El monto de apertura para la nueva cuenta debe ser una cantidad positiva!';
        END IF;
    ELSE
        SELECT '¡Ya existe la cuenta que quiere registrar!' AS error_registrarCuenta;
    END IF;
END //
-- realizarCompra
CREATE PROCEDURE BD1P2.realizarCompra(
    IN idC            BIGINT,
    IN fechaC         VARCHAR(30),
    IN importeC       FLOAT(2),
    IN otrosDetallesC VARCHAR(255),
    IN idbienC        BIGINT,
    IN idclienteC     BIGINT
) BEGIN
    DECLARE existeCompra BOOLEAN DEFAULT FALSE;
    DECLARE tipo         BIGINT DEFAULT -1;
    DECLARE idcliente    BIGINT DEFAULT -1;
    DECLARE fechaNueva   DATETIME DEFAULT NOW();
    IF LENGTH(fechaC) > 0 THEN
		SET fechaNueva = STR_TO_DATE(fechaC, '%d/%m/%Y');
    END IF;
    SELECT TRUE INTO existeCompra FROM BD1P2.Compra WHERE id = idC;
    SELECT tipobien_id INTO tipo FROM BD1P2.Bien WHERE id = idbienC;
    SELECT id INTO idcliente FROM BD1P2.Cliente WHERE id = idclienteC;
    IF NOT existeCompra THEN
        IF tipo = 2 THEN
            IF importeC > 0 THEN
                IF idcliente != -1 THEN
                    INSERT INTO BD1P2.Compra (id, fecha, importe, otros_detalles, bien_id, cliente_id) VALUE
                    (idC, fechaNueva, importeC, otrosDetallesC, idbienC, idclienteC);
                ELSE
                    SELECT '¡No existe el cliente que quiere registrar en la compra!' AS error_realizarCompra;
                    -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe el cliente que quiere registrar en la compra!';
                END IF;
            ELSE
                SELECT '¡El importe de la compra de un producto debe ser una cantidad positiva mayor que cero!' AS error_realizarCompra;
                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El importe de la compra de un producto debe ser una cantidad positiva mayor que cero!';
            END IF;
        ELSE IF tipo = 1 THEN
            IF importeC = 0 THEN
                IF idcliente != -1 THEN
                    INSERT INTO BD1P2.Compra (id, fecha, importe, otros_detalles, bien_id, cliente_id) VALUE
                    (idC, fechaNueva, importeC, otrosDetallesC, idbienC, idclienteC);
                ELSE
                    SELECT '¡No existe el cliente que quiere registrar en la compra!' AS error_realizarCompra;
                    -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe el cliente que quiere registrar en la compra!';
                END IF;
            ELSE
                SELECT '¡El importe de la compra de un servicio debe ser igual a cero!' AS error_realizarCompra;
                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El importe de la compra de un servicio debe ser igual a cero!';
            END IF;
        ELSE
            SELECT '¡Solo existen 1. Servicio 2. Producto para realizar una compra!' AS error_realizarCompra;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡Solo existen 1. Servicio 2. Producto para realizar una compra!';
        END IF;
        END IF;
    ELSE
        SELECT '¡La compra que intenta registrar ya existe!' AS error_realizarCompra;
    END IF;
END //
-- realizarDeposito
CREATE PROCEDURE BD1P2.realizarDeposito(
    IN idD            BIGINT,
    IN fechaD         VARCHAR(30),
    IN montoD         FLOAT(2),
    IN otrosDetallesD VARCHAR(255),
    IN idclienteD     BIGINT
) BEGIN
    DECLARE existeDeposito BOOLEAN DEFAULT FALSE;
    DECLARE existeUsuario  BOOLEAN DEFAULT FALSE;
    DECLARE fechaNueva   DATETIME DEFAULT NOW();
    IF LENGTH(fechaD) > 0 THEN
		SET fechaNueva = STR_TO_DATE(fechaD, '%d/%m/%Y');
    END IF;
    SELECT TRUE INTO existeDeposito FROM BD1P2.Deposito WHERE id = idD;
    SELECT TRUE INTO existeUsuario FROM BD1P2.Cliente WHERE id = idclienteD;
    IF NOT existeDeposito THEN
        IF existeUsuario THEN
            IF montoD > 0 THEN
                INSERT INTO BD1P2.Deposito (id, fecha, monto, otros_detalles, cliente_id) value
                (idD, fechaNueva, montoD, otrosDetallesD, idclienteD);
            ELSE
                SELECT '¡El monto del depósito debe ser mayor que cero!' AS error_msg;
                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El monto del depósrealizarDeposito debe ser mayor que cero!';
            END IF;
        ELSE
            SELECT '¡No existe el cliente al que quiere vincular el depósito!' AS error_realizarDeposito;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe el usuario al que quiere vincular el depósito!';
        END IF;
    ELSE
        SELECT '¡El depósito que intenta registrar ya existe!' AS error_realizarDeposito;
    END IF;
END //
-- realizarDebito
CREATE PROCEDURE BD1P2.realizarDebito(
    IN idD            BIGINT,
    IN fechaD         VARCHAR(30),
    IN montoD         FLOAT(2),
    IN otrosDetallesD VARCHAR(255),
    IN idclienteD     BIGINT
) BEGIN
    DECLARE existeDebito  BOOLEAN DEFAULT FALSE;
    DECLARE existeUsuario BOOLEAN DEFAULT FALSE;
    DECLARE fechaNueva   DATETIME DEFAULT NOW();
    IF LENGTH(fechaD) > 0 THEN
		SET fechaNueva = STR_TO_DATE(fechaD, '%d/%m/%Y');
    END IF;
    SELECT TRUE INTO existeDebito FROM BD1P2.Debito WHERE id = idD;
    SELECT TRUE INTO existeUsuario FROM BD1P2.Cliente WHERE id = idclienteD;
    IF NOT existeDebito THEN
        IF existeUsuario THEN
            IF montoD > 0 THEN
                INSERT INTO BD1P2.Debito (id, fecha, monto, otros_detalles, cliente_id) value
                (idD, fechaNueva, montoD, otrosDetallesD, idclienteD);
            ELSE
                SELECT '¡El monto del débito debe ser mayor que cero!' AS error_realizarDebito;
                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El monto del débito debe ser mayor que cero!';
            END IF;
        ELSE
            SELECT '¡No existe el usuario al que quiere vincular el débito!' AS error_realizarDebito;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe el usuario al que quiere vincular el débito!';
        END IF;
    ELSE
        SELECT '¡El débito que intenta registrar ya existe!' AS error_realizarDebito;
    END IF;
END //
-- asignarTransaccion
CREATE PROCEDURE BD1P2.asignarTransaccion(
    IN idT              BIGINT,
    IN fechaT           VARCHAR(30),
    IN otrosDetallesD   VARCHAR(255),
    IN tipotransaccionD BIGINT,
    IN idaccionD        BIGINT,
    IN idcuentaD        BIGINT
) BEGIN
    DECLARE existeCuenta      BIGINT DEFAULT FALSE;
    DECLARE tipotransaccion   BIGINT DEFAULT -1;
    DECLARE existetransaccion BOOLEAN DEFAULT FALSE;
    DECLARE esCuentacorrecta  BOOLEAN DEFAULT FALSE;
    DECLARE saldoCuenta       FLOAT(2) DEFAULT 0;
    DECLARE montoTransaccion  FLOAT(2) DEFAULT 0;
    DECLARE esServicio        BOOLEAN DEFAULT FALSE;
    DECLARE fechaNueva   DATETIME DEFAULT NOW();
    IF LENGTH(fechaT) > 0 THEN
		SET fechaNueva = STR_TO_DATE(fechaT, '%d/%m/%Y');
    END IF;
    SELECT TRUE INTO existeCuenta FROM BD1P2.Cuenta WHERE id = idcuentaD;
    IF existeCuenta THEN
        SELECT id INTO tipotransaccion FROM BD1P2.TipoTransaccion WHERE id = tipotransaccionD;
        IF tipotransaccion != -1 THEN
            IF tipotransaccion = 1 THEN -- COMPRA
                SELECT TRUE INTO existetransaccion FROM BD1P2.Compra WHERE id = idaccionD;
            ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
                SELECT TRUE INTO existetransaccion FROM BD1P2.Deposito WHERE id = idaccionD;
            ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
                SELECT TRUE INTO existetransaccion FROM BD1P2.Debito WHERE id = idaccionD;
            END IF;
            END IF;
            END IF;
            IF existetransaccion THEN
                IF tipotransaccion = 1 THEN -- COMPRA
                    SELECT TRUE INTO esCuentacorrecta FROM BD1P2.Cuenta c
                    INNER JOIN BD1P2.Compra co ON c.cliente_id = co.cliente_id
                    WHERE c.id = idcuentaD AND co.id = idaccionD;
                ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
                    SELECT TRUE INTO esCuentacorrecta FROM BD1P2.Cuenta c
                    INNER JOIN BD1P2.Deposito d ON c.cliente_id = d.cliente_id
                    WHERE c.id = idcuentaD AND d.id = idaccionD;
                ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
                    SELECT TRUE INTO esCuentacorrecta FROM BD1P2.Cuenta c
                    INNER JOIN BD1P2.Debito d ON c.cliente_id = d.cliente_id
                    WHERE c.id = idcuentaD AND d.id = idaccionD;
                END IF;
                END IF;
                END IF;
                IF esCuentacorrecta THEN
                    IF tipotransaccion = 1 OR tipotransaccion = 3 THEN
                        SELECT saldo INTO saldoCuenta FROM BD1P2.Cuenta WHERE id = idcuentaD;
                    END IF;
                    IF tipotransaccion = 1 THEN -- COMPRA
                        SELECT TRUE INTO esServicio
                        FROM BD1P2.Compra c
                        INNER JOIN BD1P2.Bien b ON c.bien_id = b.id
                        WHERE c.id = idaccionD AND b.tipobien_id = 1;
                        IF esServicio THEN
                            SELECT b.costo INTO montoTransaccion
                            FROM BD1P2.Compra c
                            INNER JOIN BD1P2.Bien b ON c.bien_id = b.id
                            WHERE c.id = idaccionD AND b.tipobien_id = 1;
                        ELSE
                            SELECT importe INTO montoTransaccion FROM BD1P2.Compra WHERE id = idaccionD;
                        END IF;
                    ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
                        SELECT monto INTO montoTransaccion FROM BD1P2.Deposito WHERE id = idaccionD;
                    ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
                        SELECT monto INTO montoTransaccion FROM BD1P2.Debito WHERE id = idaccionD;
                    END IF;
                    END IF;
                    END IF;
                    IF tipotransaccion = 1 OR tipotransaccion = 3 THEN -- COMPRA O DEBITO
                        IF saldoCuenta >= montoTransaccion THEN
                            UPDATE BD1P2.Cuenta SET saldo = saldo - montoTransaccion WHERE id = idcuentaD;
                            IF tipotransaccion = 1 THEN
                                INSERT INTO BD1P2.Transaccion (fecha, otros_detalles , cuenta_id, tipotransaccion_id, compra_id) VALUE
                                (fechaNueva, otrosDetallesD, idcuentaD, tipotransaccionD, idaccionD);
                            ELSE IF tipotransaccion = 3 THEN
                                INSERT INTO BD1P2.Transaccion (fecha, otros_detalles , cuenta_id, tipotransaccion_id, debito_id) VALUE
                                (fechaNueva, otrosDetallesD, idcuentaD, tipotransaccionD, idaccionD);
                            END IF;
                            END IF;
                        ELSE
                            IF tipotransaccion = 1 THEN -- COMPRA
                                SELECT '¡El saldo en la cuenta es insuficiente para realizar la compra!' AS error_asignarTransaccion;
                                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El saldo en la cuenta es insuficiente para realizar la compra!';
                            ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
                                SELECT '¡El saldo en la cuenta es insuficiente para realizar el débito!' AS error_asignarTransaccion;
                                -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡El saldo en la cuenta es insuficiente para realizar el débito!';
                            END IF;
                            END IF;
                        END IF;
                    ELSE -- DEPOSITO
                        UPDATE BD1P2.Cuenta SET saldo = saldo + montoTransaccion WHERE id = idcuentaD;
                        INSERT INTO BD1P2.Transaccion (fecha, otros_detalles , cuenta_id, tipotransaccion_id, deposito_id) VALUE
                        (fechaNueva, otrosDetallesD, idcuentaD, tipotransaccionD, idaccionD);
                    END IF;
                ELSE
                    IF tipotransaccion = 1 THEN -- COMPRA
                        SELECT '¡La cuenta y la compra no corresponden al mismo cliente!' AS error_asignarTransaccion;
                        -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡La cuenta y la compra no corresponden al mismo cliente!';
                    ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
                        SELECT '¡La cuenta y el depósito no corresponden al mismo cliente!' AS error_asignarTransaccion;
                        -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡La cuenta y el depósito no corresponden al mismo cliente!';
                    ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
                        SELECT '¡La cuenta y el débito no corresponden al mismo cliente!' AS error_asignarTransaccion;
                        -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡La cuenta y el débito no corresponden al mismo cliente!';
                    END IF;
                    END IF;
                    END IF;
                END IF;
            ELSE
                IF tipotransaccion = 1 THEN -- COMPRA
                    SELECT '¡No existe la compra que quiere vincular a la transacción!' AS error_asignarTransaccion;
                    -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe la compra que quiere vincular a la transacción!';
                ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
                    SELECT '¡No existe el depósito que quiere vincular a la transacción!' AS error_asignarTransaccion;
                    -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe el depósito que quiere vincular a la transacción!';
                ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
                    SELECT '¡No existe el débito que quiere vincular a la transacción!' AS error_asignarTransaccion;
                    -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe el débito que quiere vincular a la transacción!';
                END IF;
                END IF;
                END IF;
            END IF;
        ELSE
            SELECT '¡No existe el tipo de transaccion que quiere registrar!' AS error_asignarTransaccion;
            -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe el tipo de transaccion que quiere registrar!';
        END IF;
    ELSE
        SELECT '¡No existe la cuenta con la que quiere realizar una transacción!' AS error_asignarTransaccion;
        -- SIGNAL SQLSTATE '07S01' SET MESSAGE_TEXT = '¡No existe la cuenta con la que quiere realizar una transacción!';
    END IF;
END //
DELIMITER ;