SELECT * FROM BD1P2.TipoCliente;
SELECT * FROM BD1P2.TipoCuenta;
SELECT * FROM BD1P2.TipoTransaccion;
SELECT b.id, b.costo, b.descripcion, CONCAT(tb.nombre, ' = ', tb.id) AS tipo FROM BD1P2.Bien b
INNER JOIN BD1P2.TipoBien tb ON b.tipobien_id = tb.id;

SELECT * FROM BD1P2.Bien;
SELECT * FROM BD1P2.Cuenta;
SELECT * FROM BD1P2.Cliente;
SELECT * FROM BD1P2.Telefono;
SELECT * FROM BD1P2.Correo;
SELECT * FROM BD1P2.Transaccion;
SELECT * FROM BD1P2.Historial;

SELECT COUNT(DISTINCT cliente_id) FROM BD1P2.Cuenta WHERE cliente_id = 1001;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE BD1P2.TipoBien;
TRUNCATE TABLE BD1P2.TipoCliente;
TRUNCATE TABLE BD1P2.TipoCuenta;
TRUNCATE TABLE BD1P2.TipoTransaccion;
TRUNCATE TABLE BD1P2.Bien;
TRUNCATE TABLE BD1P2.Cliente;
TRUNCATE TABLE BD1P2.Telefono;
TRUNCATE TABLE BD1P2.Correo;
TRUNCATE TABLE BD1P2.Cuenta;
TRUNCATE TABLE BD1P2.Compra;
TRUNCATE TABLE BD1P2.Debito;
TRUNCATE TABLE BD1P2.Deposito;
TRUNCATE TABLE BD1P2.Transaccion;
TRUNCATE TABLE BD1P2.Historial;
SET FOREIGN_KEY_CHECKS = 1;



/*




*/

SELECT TRUE FROM BD1P2.Cuenta WHERE id = 20250001;
SELECT id FROM BD1P2.TipoTransaccion WHERE id = 1;
SELECT TRUE FROM BD1P2.Compra WHERE id = 503801;
SELECT TRUE FROM BD1P2.Deposito WHERE id = 503801;
SELECT TRUE FROM BD1P2.Debito WHERE id = 503801;
SELECT * FROM BD1P2.Cuenta c
                    INNER JOIN BD1P2.Compra co ON c.cliente_id = co.cliente_id
                    WHERE c.id = 20250001 AND co.id = 503801;
SELECT TRUE FROM BD1P2.Cuenta c
                    INNER JOIN BD1P2.Deposito d ON c.cliente_id = d.cliente_id
                    WHERE c.id = 20250001 AND d.id = 503801;
SELECT TRUE FROM BD1P2.Cuenta c
                    INNER JOIN BD1P2.Debito d ON c.cliente_id = d.cliente_id
                    WHERE c.id = 20250001 AND d.id = 503801;
SELECT saldo FROM BD1P2.Cuenta WHERE id = 20250001;
SELECT TRUE
                        FROM BD1P2.Compra c
                        INNER JOIN BD1P2.Bien b ON c.bien_id = b.id
                        WHERE c.id = 503801 AND b.tipobien_id = 1;
SELECT b.costo
                            FROM BD1P2.Compra c
                            INNER JOIN BD1P2.Bien b ON c.bien_id = b.id
                            WHERE c.id = 503801 AND b.tipobien_id = 1;
SELECT importe FROM BD1P2.Compra WHERE id = 503801;
SELECT monto FROM BD1P2.Deposito WHERE id = 503801;
SELECT monto FROM BD1P2.Debito WHERE id = 503801;