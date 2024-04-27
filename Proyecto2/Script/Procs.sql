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
	IN idTC          INTEGER,
	IN nombreTC      VARCHAR(40),
	IN descripcionTC VARCHAR(200)
) BEGIN
	IF descripcionTC REGEXP '^[[:alpha:]]+$' THEN
		INSERT INTO BD1P2.TipoCliente (nombre, descripcion) VALUES
		(nombreTC, descripcionTC);
	ELSE
		SELECT '¡LA DESCRIPCIÓN DEL TIPO DE CLIENTE DEBE CONTENER SOLO LETRAS!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡LA DESCRIPCIÓN DEL TIPO DE CLIENTE DEBE CONTENER SOLO LETRAS!';
	END IF;
END //
-- registrarTipoCuenta
CREATE PROCEDURE BD1P2.registrarTipoCuenta(
	IN idTC          INTEGER,
	IN nombreTC      VARCHAR(40),
	IN descripcionTC VARCHAR(200)
) BEGIN
	INSERT INTO BD1P2.TipoCuenta (nombre, descripcion) VALUES
	(nombreTC, descripcionTC);
END //
-- registrarTipoTransaccion
CREATE PROCEDURE BD1P2.registrarTipoTransaccion(
	IN idTC          INTEGER,
	IN nombreTC      VARCHAR(40),
	IN descripcionTC VARCHAR(255)
) BEGIN
	INSERT INTO BD1P2.TipoTransaccion (nombre, descripcion) VALUES
	(nombreTC, descripcionTC);
END //
-- crearProductoServicio
CREATE PROCEDURE BD1P2.crearProductoServicio(
	IN idPS          INTEGER,
	IN tipoPS        INTEGER,
	IN costoPS       FLOAT(2),
	IN descripcionPS VARCHAR(200)
) BEGIN
	IF tipoPS = 1 AND costoPS > 0 OR tipoPS = 2 AND costPS >= 0 THEN
		INSERT INTO BD1P2.Bien (id, costo, descripcion, tipobien_id) VALUES
		(idPS, costoPS, descripcionPS, tipoPS);
	ELSE IF tipoPS = 1 AND costoPS <= 0 THEN
		SELECT '¡COSTO INCORRECTO PARA UN SERVICIO!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡COSTO INCORRECTO PARA UN SERVICIO!';
	ELSE IF tipoPS = 2 AND costPS < 0 THEN
		SELECT '¡COSTO INCORRECTO PARA UN PRODUCTO!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡COSTO INCORRECTO PARA UN PRODUCTO!';
	END IF;
	END IF;
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
	IN clienteid INTEGER
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
	IN clienteid INTEGER
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
	IN idC         INTEGER,
	IN nombreC     VARCHAR(40),
	IN apellidosC  VARCHAR(40),
	IN telefonosC  VARCHAR(255),
	IN correosC    VARCHAR(40),
	IN usuarioC    VARCHAR(40),
	IN contrasenaC VARCHAR(200),
	IN idtipoC     INTEGER
) BEGIN
	DECLARE correos_validos      BOOLEAN;
	DECLARE telefonos_procesados VARCHAR(255);
	DECLARE usuarioUsado         BOOLEAN DEFAULT FALSE;
	IF nombreC REGEXP '^[[:alpha:]]+$' THEN
		IF apellidosC REGEXP '^[[:alpha:]]+$' THEN
			SELECT TRUE INTO usuarioUsado FROM BD1P2.Cliente WHERE usuario = usuarioC;
			IF usuarioUsado THEN
				SET correos_validos = BD1P2.procesarCorreos(correosC);
				IF corres_validos THEN
					SET telefonos_procesados = BD1P2.procesarTelefonos(telefonosC);
					INSERT INTO BD1P2.Cliente (id, nombre, apellidos, usuario, contrasena, fechacreacion, tipocliente_id) VALUES
					(idC, nombreC, apellidosC, usuarioC, HEX(AES_ENCRYPT(contrasenaC, @clave)), CURDATE(), idtipoC);
				ELSE
					SELECT '¡El formato del o los correos del usuario que intenta registrar no son correctos!';
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El formato del o los correos del usuario que intenta registrar no son correctos!';
				END IF;
			ELSE
				SELECT '¡El nombre de usuario ya se encuentra en uso!';
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El nombre de usuario ya se encuentra en uso!';
			END IF;
		ELSE
			SELECT '¡El apellido del usuario que intenta registrar contiene caracteres extraños!';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El apellido del usuario que intenta registrar contiene caracteres extraños!';
		END IF;
	ELSE
		SELECT '¡El nombre del usuario que intenta registrar contiene caracteres extraños!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El nombre del usuario que intenta registrar contiene caracteres extraños!';
	END IF;
END //
-- registrarCuenta
CREATE PROCEDURE BD1P2.registrarCuenta(
	IN idC          INTEGER,
	IN montoApC     FLOAT(2),
	IN saldoC       FLOAT(2),
	IN descripcionC VARCHAR(255),
	IN fechaApC     VARCHAR(30),
	IN otrosdetC    VARCHAR(255),
	IN tipocuentaC  INTEGER,
	IN idclienteC   INTEGER
) BEGIN
	DECLARE idtipocuenta INTEGER DEFAULT -1;
	DECLARE idcliente    INTEGER DEFAULT -1;
	IF montoApC > 0 THEN
		IF saldoC >= 0 THEN
			SELECT id INTO idtipocuenta FROM BD1P2.TipoCuenta WHERE id = tipocuentaC;
			IF idtipocuenta != -1 THEN
				SELECT id INTO idcliente FROM BD1P2.Cliente WHERE id = idclienteC;
				IF idcliente != -1 THEN
					INSERT INTO BD1P2.Cuenta (id, monto_apertura, saldo, descripcion, fecha_apertura, otros_detalles, tipocuenta_id, cliente_id) VALUES
					(idC, montoApC, saldoC, descripcionC, NOW(), otrosdetC, tipocuentaC, idclienteC);
				ELSE
					SELECT '¡Intenta vincular la cuenta a un cliente inexistente!';
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡Intenta vincular la cuenta a un cliente inexistente!';
				END IF;
			ELSE
				SELECT '¡Intenta asignar un tipo inexistente a la cuenta!';
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡Intenta asignar un tipo inexistente a la cuenta!';
			END IF;
		ELSE
			SELECT '¡El saldo para la nueva cuenta debe ser una cantidad positiva!';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El saldo para la nueva cuenta debe ser una cantidad positiva!';
		END IF;
	ELSE
		SELECT '¡El monto de apertura para la nueva cuenta debe ser una cantidad positiva!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El monto de apertura para la nueva cuenta debe ser una cantidad positiva!';
	END IF;
END //
-- realizarCompra
CREATE PROCEDURE BD1P2.realizarCompra(
	IN idC            INTEGER,
	IN fechaC         VARCHAR(30),
	IN importeC       FLOAT(2),
	IN otrosDetallesC VARCHAR(255),
	IN idbienC        INTEGER,
	IN idclienteC     INTEGER
) BEGIN
	DECLARE tipo      INTEGER DEFAULT -1;
	DECLARE idcliente INTEGER DEFAULT -1;
	SELECT tipobien_id INTO tipo FROM BD1P2.Bien WHERE id = idbienC;
	SELECT id INTO idcliente FROM BD1P2.Cliente WHERE id = idclienteC;
	IF tipo = 2 THEN
		IF importeC > 0 THEN
			IF idcliente != -1 THEN
				INSERT INTO BD1P2.Compra (id, fecha, importe, otros_detalles, bien_id, cliente_id) VALUE
				(idC, STR_TO_DATE(fechaC, '%d/%m/%Y'), importeC, otrosDetallesC, idbienC, idclienteC);
			ELSE
				SELECT '¡No existe el cliente que quiere registrar en la compra!';
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe el cliente que quiere registrar en la compra!';
			END IF;
		ELSE
			SELECT '¡El importe de la compra de un producto debe ser una cantidad positiva mayor que cero!';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El importe de la compra de un producto debe ser una cantidad positiva mayor que cero!';
		END IF;
	ELSE IF tipo = 1 THEN
		IF importeC = 0 THEN
			IF idcliente != -1 THEN
				INSERT INTO BD1P2.Compra (id, fecha, importe, otros_detalles, bien_id, cliente_id) VALUE
				(idC, STR_TO_DATE(fechaC, '%d/%m/%Y'), importeC, otrosDetallesC, idbienC, idclienteC);
			ELSE
				SELECT '¡No existe el cliente que quiere registrar en la compra!';
				SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe el cliente que quiere registrar en la compra!';
			END IF;
		ELSE
			SELECT '¡El importe de la compra de un servicio debe ser igual a cero!';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El importe de la compra de un servicio debe ser igual a cero!';
		END IF;
	ELSE
		SELECT '¡Solo existen 1. Servicio 2. Producto para realizar una compra!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡Solo existen 1. Servicio 2. Producto para realizar una compra!';
	END IF;
	END IF;
END //
-- realizarDeposito
CREATE PROCEDURE BD1P2.realizarDeposito(
	IN idD            INTEGER,
	IN fechaD         VARCHAR(30),
	IN montoD         FLOAT(2),
	IN otrosDetallesD VARCHAR(255),
	IN idclienteD     INTEGER
) BEGIN
	DECLARE existeUsuario BOOLEAN DEFAULT FALSE;
	SELECT TRUE INTO existeUsuario FROM BD1P2.Cliente WHERE id = idclienteD;
	IF existeUsuario THEN
		IF montoD > 0 THEN
			INSERT INTO BD1P2.Deposito (id, fecha, monto, otros_detalles, cliente_id) value
			(idD, STR_TO_DATE(fechaD, '%d/%m/%Y'), montoD, otrosDetallesD, idclienteD);
		ELSE
			SELECT '¡El monto del depósito debe ser mayor que cero!';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El monto del depósito debe ser mayor que cero!';
		END IF;
	ELSE
		SELECT '¡No existe el usuario al que quiere vincular el depósito!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe el usuario al que quiere vincular el depósito!';
	END IF;
END //
-- realizarDebito
CREATE PROCEDURE BD1P2.realizarDebito(
	IN idD            INTEGER,
	IN fechaD         VARCHAR(30),
	IN montoD         FLOAT(2),
	IN otrosDetallesD VARCHAR(255),
	IN idclienteD     INTEGER
) BEGIN
	DECLARE existeUsuario BOOLEAN DEFAULT FALSE;
	SELECT TRUE INTO existeUsuario FROM BD1P2.Cliente WHERE id = idclienteD;
	IF existeUsuario THEN
		IF montoD > 0 THEN
			INSERT INTO BD1P2.Debito (id, fecha, monto, otros_detalles, cliente_id) value
			(idD, STR_TO_DATE(fechaD, '%d/%m/%Y'), montoD, otrosDetallesD, idclienteD);
		ELSE
			SELECT '¡El monto del débito debe ser mayor que cero!';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El monto del débito debe ser mayor que cero!';
		END IF;
	ELSE
		SELECT '¡No existe el usuario al que quiere vincular el débito!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe el usuario al que quiere vincular el débito!';
	END IF;
END //
-- asignarTransaccion
CREATE PROCEDURE BD1P2.asignarTransaccion(
	IN idT              INTEGER,
	IN fechaT           VARCHAR(30),
	IN otrosDetallesD   VARCHAR(255),
	IN tipotransaccionD INTEGER,
	IN idaccionD        INTEGER,
	IN idcuentaD        INTEGER
) BEGIN
	DECLARE existeCuenta      INTEGER DEFAULT FALSE;
	DECLARE tipotransaccion   INTEGER DEFAULT -1;
	DECLARE existetransaccion BOOLEAN DEFAULT FALSE;
	DECLARE esCuentacorrecta  BOOLEAN DEFAULT FALSE;
	DECLARE saldoCuenta       FLOAT(2) DEFAULT 0;
	DECLARE montoTransaccion  FLOAT(2) DEFAULT 0;
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
					WHERE c.id = idcuentaD;
				ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
					SELECT TRUE INTO esCuentacorrecta FROM BD1P2.Cuenta c
					INNER JOIN BD1P2.Deposito d ON c.cliente_id = d.cliente_id
					WHERE c.id = idcuentaD;
				ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
					SELECT TRUE INTO esCuentacorrecta FROM BD1P2.Cuenta c
					INNER JOIN BD1P2.Debito d ON c.cliente_id = d.cliente_id
					WHERE c.id = idcuentaD;
				END IF;
				END IF;
				END IF;
				IF esCuentacorrecta THEN
					IF tipotransaccion = 1 OR tipotransaccion = 3 THEN
						SELECT saldo INTO saldoCuenta FROM BD1P2.Cuenta WHERE id = idcuentaD;
					END IF;
					IF tipotransaccion = 1 THEN -- COMPRA
						SELECT importe INTO montoTransaccion FROM BD1P2.Compra WHERE id = idaccionD;
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
								(STR_TO_DATE(fechaT, '%d/%m/%Y'), otrosDetallesD, idcuentaD, tipotransaccionD, idaccionD);
							ELSE IF tipotransaccion = 3 THEN
								INSERT INTO BD1P2.Transaccion (fecha, otros_detalles , cuenta_id, tipotransaccion_id, debito_id) VALUE
								(STR_TO_DATE(fechaT, '%d/%m/%Y'), otrosDetallesD, idcuentaD, tipotransaccionD, idaccionD);
							END IF;
							END IF;
						ELSE
							IF tipotransaccion = 1 THEN -- COMPRA
								SELECT '¡El saldo en la cuenta es insuficiente para realizar la compra!';
								SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El saldo en la cuenta es insuficiente para realizar la compra!';
							ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
								SELECT '¡El saldo en la cuenta es insuficiente para realizar el débito!';
								SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡El saldo en la cuenta es insuficiente para realizar el débito!';
							END IF;
							END IF;
						END IF;
					ELSE -- DEPOSITO
						UPDATE BD1P2.Cuenta SET saldo = saldo + montoTransaccion WHERE id = idcuentaD;
						INSERT INTO BD1P2.Transaccion (fecha, otros_detalles , cuenta_id, tipotransaccion_id, deposito_id) VALUE
						(STR_TO_DATE(fechaT, '%d/%m/%Y'), otrosDetallesD, idcuentaD, tipotransaccionD, idaccionD);
					END IF;
				ELSE
					IF tipotransaccion = 1 THEN -- COMPRA
						SELECT '¡La cuenta y la compra no corresponden al mismo cliente!';
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡La cuenta y la compra no corresponden al mismo cliente!';
					ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
						SELECT '¡La cuenta y el depósito no corresponden al mismo cliente!';
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡La cuenta y el depósito no corresponden al mismo cliente!';
					ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
						SELECT '¡La cuenta y el débito no corresponden al mismo cliente!';
						SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡La cuenta y el débito no corresponden al mismo cliente!';
					END IF;
					END IF;
					END IF;
				END IF;
			ELSE
				IF tipotransaccion = 1 THEN -- COMPRA
					SELECT '¡No existe la compra que quiere vincular a la transacción!';
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe la compra que quiere vincular a la transacción!';
				ELSE IF tipotransaccion = 2 THEN -- DEPOSITO
					SELECT '¡No existe el depósito que quiere vincular a la transacción!';
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe el depósito que quiere vincular a la transacción!';
				ELSE IF tipotransaccion = 3 THEN -- DEPOSITO
					SELECT '¡No existe el débito que quiere vincular a la transacción!';
					SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe el débito que quiere vincular a la transacción!';
				END IF;
				END IF;
				END IF;
			END IF;
		ELSE
			SELECT '¡No existe el tipo de transaccion que quiere registrar!';
			SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe el tipo de transaccion que quiere registrar!';
		END IF;
	ELSE
		SELECT '¡No existe la cuenta con la que quiere realizar una transacción!';
		SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '¡No existe la cuenta con la que quiere realizar una transacción!';
	END IF;
END //
DELIMITER ;