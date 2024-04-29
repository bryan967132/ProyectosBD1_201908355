DROP PROCEDURE IF EXISTS BD1P2.consultarSaldoCliente;  -- 1
DROP PROCEDURE IF EXISTS BD1P2.consultarCliente;       -- 2
DROP PROCEDURE IF EXISTS BD1P2.consultarMovsCliente;   -- 3
DROP PROCEDURE IF EXISTS BD1P2.consultarTipoCuentas;   -- 4
DROP PROCEDURE IF EXISTS BD1P2.consultarMovsGenFech;   -- 5
DROP PROCEDURE IF EXISTS BD1P2.consultarMovsFechClien; -- 6
DROP PROCEDURE IF EXISTS BD1P2.consultarProductoServicio; -- 7

DELIMITER //

-- consultarSaldoCliente;  -- 1
CREATE PROCEDURE BD1P2.consultarSaldoCliente(
    IN idCuenta BIGINT
) BEGIN
    DECLARE existeCuenta BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeCuenta FROM BD1P2.Cuenta WHERE id = idCuenta;
    IF existeCuenta THEN
        SELECT CONCAT(cl.nombre, ' ', cl.apellidos) 'Nombre Cliente', tcl.nombre 'Tipo De Cliente',
            tcu.nombre 'Tipo De Cuenta', cu.saldo 'Saldo De Cuenta', cu.monto_apertura 'Saldo Apertura'
        FROM BD1P2.Cuenta cu
        INNER JOIN BD1P2.Cliente cl ON cu.cliente_id = cl.id
        INNER JOIN BD1P2.TipoCliente tcl ON cl.tipocliente_id = tcl.id
        INNER JOIN BD1P2.TipoCuenta tcu ON cu.tipocuenta_id = tcu.id
        WHERE cu.id = idCuenta;
    ELSE
        SELECT '¡La cuenta que quiere consultar no existe!' AS error_msg;
    END IF;
END //
-- consultarCliente;       -- 2
CREATE PROCEDURE BD1P2.consultarCliente(
    IN idCliente BIGINT
) BEGIN
    DECLARE existeCliente BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeCliente FROM BD1P2.Cliente WHERE id = idCliente;
    IF existeCliente THEN
        SELECT cl.id 'ID Cliente',
            CONCAT(cl.nombre, ' ', cl.apellidos) 'Nombre Cliente',
            cl.fechacreacion 'Fecha De Creación',
            cl.usuario 'Usuario', (
                SELECT GROUP_CONCAT(t.numero SEPARATOR ', ')
                FROM BD1P2.Telefono t WHERE t.cliente_id = idCliente
            ) 'Teléfono(s)', (
                SELECT GROUP_CONCAT(c.direccion SEPARATOR ', ')
                FROM BD1P2.Correo c WHERE c.cliente_id = idCliente
            ) 'Correo(s)', (
                SELECT COUNT(*) FROM BD1P2.Cuenta c
                WHERE c.cliente_id = idCliente
            ) 'Cuentas', (
                SELECT GROUP_CONCAT(DISTINCT tc.nombre SEPARATOR ', ') FROM BD1P2.Cuenta c
                INNER JOIN BD1P2.TipoCuenta tc ON c.tipocuenta_id = tc.id
                WHERE c.cliente_id = idCliente
            ) 'Tipos De Cuenta'
        FROM BD1P2.Cliente cl
        WHERE cl.id = idCliente;
    ELSE
        SELECT '¡El cliente que quiere consultar no existe!' AS error_msg;
    END IF;
END //
-- consultarMovsCliente;   -- 3
CREATE PROCEDURE BD1P2.consultarMovsCliente(
    IN idCliente BIGINT
) BEGIN
    DECLARE existeCliente BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeCliente FROM BD1P2.Cliente WHERE id = idCliente;
    IF existeCliente THEN
        SELECT * FROM (
            (
                SELECT t.id, 'Compra' AS 'Tipo Transacción', CONCAT('Q ', c.importe) Monto, b.descripcion 'Producto/Servicio', t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta'
                FROM BD1P2.Transaccion t
                INNER JOIN BD1P2.Compra c ON t.compra_id = c.id
                INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
                INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
                INNER JOIN BD1P2.Bien b ON c.bien_id = b.id
                WHERE t.compra_id IS NOT NULL AND cu.cliente_id = idCliente
            ) UNION (
                SELECT t.id, 'Depósito' AS 'Tipo Transacción', CONCAT('Q ', d.monto) Monto, 'Crédito' AS 'Producto/Servicio', t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta'
                FROM BD1P2.Transaccion t
                INNER JOIN BD1P2.Deposito d ON t.deposito_id = d.id
                INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
                INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
                WHERE t.deposito_id IS NOT NULL AND cu.cliente_id = idCliente
            ) UNION (
                SELECT t.id, 'Débito' AS 'Tipo Transacción', CONCAT('Q ', d.monto) Monto, 'Débito' AS 'Producto/Servicio', t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta'
                FROM BD1P2.Transaccion t
                INNER JOIN BD1P2.Debito d ON t.debito_id = d.id
                INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
                INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
                WHERE t.debito_id IS NOT NULL AND cu.cliente_id = idCliente
            )
        ) t ORDER BY t.id ASC;
    ELSE
        SELECT '¡El cliente que quiere consultar no existe!' AS error_msg;
    END IF;
END //
-- consultarTipoCuentas;   -- 4
CREATE PROCEDURE BD1P2.consultarTipoCuentas(
    IN idTC BIGINT
) BEGIN
    DECLARE existeTipo BOOLEAN DEFAULT FALSE;
    SELECT TRUE INTO existeTipo FROM BD1P2.TipoCuenta WHERE id = idTC;
    IF existeTipo THEN
        SELECT tc.id 'Código', tc.nombre 'Nombre Cuenta', (
            SELECT COUNT(*) FROM BD1P2.Cuenta c WHERE c.tipocuenta_id = tc.id
        ) 'Cantidad De Clientes'
        FROM BD1P2.TipoCuenta tc
        WHERE tc.id = idTC;
    END IF;
END //
-- consultarMovsGenFech;   -- 5
CREATE PROCEDURE BD1P2.consultarMovsGenFech(
    IN fechainicio VARCHAR(30),
    IN fechafinal  VARCHAR(30)
) BEGIN
    SELECT * FROM (
        (
            SELECT t.id, 'Compra' AS 'Tipo Transacción', b.descripcion 'Producto/Servicio', cl.nombre 'Cliente',
                t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta', t.fecha 'Fecha', CONCAT('Q ', c.importe) Monto, t.otros_detalles 'Detalles'
            FROM BD1P2.Transaccion t
            INNER JOIN BD1P2.Compra c ON t.compra_id = c.id
            INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
            INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
            INNER JOIN BD1P2.Bien b ON c.bien_id = b.id
            INNER JOIN BD1P2.Cliente cl ON cu.cliente_id = cl.id
            WHERE t.compra_id IS NOT NULL AND t.fecha BETWEEN STR_TO_DATE(fechainicio, '%d/%m/%Y') AND STR_TO_DATE(fechafinal, '%d/%m/%Y')
        ) UNION (
            SELECT t.id, 'Depósito' AS 'Tipo Transacción', 'Crédito' AS 'Producto/Servicio', cl.nombre 'Cliente',
                t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta', t.fecha 'Fecha', CONCAT('Q ', d.monto) Monto, t.otros_detalles 'Detalles'
            FROM BD1P2.Transaccion t
            INNER JOIN BD1P2.Deposito d ON t.deposito_id = d.id
            INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
            INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
            INNER JOIN BD1P2.Cliente cl ON cu.cliente_id = cl.id
            WHERE t.deposito_id IS NOT NULL AND t.fecha BETWEEN STR_TO_DATE(fechainicio, '%d/%m/%Y') AND STR_TO_DATE(fechafinal, '%d/%m/%Y')
        ) UNION (
            SELECT t.id, 'Débito' AS 'Tipo Transacción', 'Débito' AS 'Producto/Servicio', cl.nombre 'Cliente',
                t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta', t.fecha 'Fecha', CONCAT('Q ', d.monto) Monto, t.otros_detalles 'Detalles'
            FROM BD1P2.Transaccion t
            INNER JOIN BD1P2.Debito d ON t.debito_id = d.id
            INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
            INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
            INNER JOIN BD1P2.Cliente cl ON cu.cliente_id = cl.id
            WHERE t.debito_id IS NOT NULL AND t.fecha BETWEEN STR_TO_DATE(fechainicio, '%d/%m/%Y') AND STR_TO_DATE(fechafinal, '%d/%m/%Y')
        )
    ) t ORDER BY t.id ASC;
END //
-- consultarMovsFechClien; -- 6
CREATE PROCEDURE BD1P2.consultarMovsFechClien(
    IN idCliente   BIGINT,
    IN fechainicio VARCHAR(30),
    IN fechafinal  VARCHAR(30)
) BEGIN
    SELECT * FROM (
        (
            SELECT t.id, 'Compra' AS 'Tipo Transacción', b.descripcion 'Producto/Servicio', cl.nombre 'Cliente',
                t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta', t.fecha 'Fecha', CONCAT('Q ', c.importe) Monto, t.otros_detalles 'Detalles'
            FROM BD1P2.Transaccion t
            INNER JOIN BD1P2.Compra c ON t.compra_id = c.id
            INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
            INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
            INNER JOIN BD1P2.Bien b ON c.bien_id = b.id
            INNER JOIN BD1P2.Cliente cl ON cu.cliente_id = cl.id
            WHERE t.compra_id IS NOT NULL AND t.fecha BETWEEN STR_TO_DATE(fechainicio, '%d/%m/%Y') AND STR_TO_DATE(fechafinal, '%d/%m/%Y')
            AND cl.id = idCliente
        ) UNION (
            SELECT t.id, 'Depósito' AS 'Tipo Transacción', 'Crédito' AS 'Producto/Servicio', cl.nombre 'Cliente',
                t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta', t.fecha 'Fecha', CONCAT('Q ', d.monto) Monto, t.otros_detalles 'Detalles'
            FROM BD1P2.Transaccion t
            INNER JOIN BD1P2.Deposito d ON t.deposito_id = d.id
            INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
            INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
            INNER JOIN BD1P2.Cliente cl ON cu.cliente_id = cl.id
            WHERE t.deposito_id IS NOT NULL AND t.fecha BETWEEN STR_TO_DATE(fechainicio, '%d/%m/%Y') AND STR_TO_DATE(fechafinal, '%d/%m/%Y')
            AND cl.id = idCliente
        ) UNION (
            SELECT t.id, 'Débito' AS 'Tipo Transacción', 'Débito' AS 'Producto/Servicio', cl.nombre 'Cliente',
                t.cuenta_id 'No. Cuenta', tc.nombre 'Tipo Cuenta', t.fecha 'Fecha', CONCAT('Q ', d.monto) Monto, t.otros_detalles 'Detalles'
            FROM BD1P2.Transaccion t
            INNER JOIN BD1P2.Debito d ON t.debito_id = d.id
            INNER JOIN BD1P2.Cuenta cu ON t.cuenta_id = cu.id
            INNER JOIN BD1P2.TipoCuenta tc ON cu.tipocuenta_id = tc.id
            INNER JOIN BD1P2.Cliente cl ON cu.cliente_id = cl.id
            WHERE t.debito_id IS NOT NULL AND t.fecha BETWEEN STR_TO_DATE(fechainicio, '%d/%m/%Y') AND STR_TO_DATE(fechafinal, '%d/%m/%Y')
            AND cl.id = idCliente
        )
    ) t ORDER BY t.id ASC;
END //
-- consultarDesasignacion; -- 7
CREATE PROCEDURE BD1P2.consultarProductoServicio() BEGIN
    SELECT b.id 'Código Producto/Servicio', b.descripcion 'Nombre', CONCAT('Tipo = ', b.tipobien_id) 'Descripción', tb.nombre 'Tipo'
    FROM BD1P2.Bien b
    INNER JOIN BD1P2.TipoBien tb ON b.tipobien_id = tb.id;
END //
DELIMITER ;