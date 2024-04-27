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