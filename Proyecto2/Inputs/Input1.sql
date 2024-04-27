USE BD1P2;

-- registroTipoCliuente
--                  idtipo,     nombre,                         descripcion
CALL registrarTipoCliente(4, 'Cliente Extraordinario', 'Este cliente no esta definido en el enunciado, es un tipo de cliente extra');

-- registros de cliente 
--            idcliente,   nombre,    apellido,    telefono,       correo,            usuario,  contrasena,tipo
CALL registrarCliente(1001, 'Juan Isaac', 'Perez Lopez', '22888080', 'micorreo@gmail.com', 'jisaacp2024', '12345678', '1' );
CALL registrarCliente(1002, 'Maria Isabel', 'Gonzalez Perez', '22805050-22808080', 'micorreo1@gmail.com|micorreo2@gmail.com', 'mariauser', '12345679', '2' );

-- registro de tipo de cuenta
--                   idtipo,     nombre,            descripcion
CALL registrarTipoCuenta(7, 'Cuenta Extraordinaria', 'Cuenta Extraordinaria a enunciado');

-- registro de cuenta
--            idcuenta, montoapertura,*saldo, descripcion,     fechaapertura,otrosdetalles,idtipocuenta,idcliente
CALL registrarCuenta(3030206080, 500.00, 800.00, 'Apertura de cuenta con Q500', '', '',5,1001);
CALL registrarCuenta(3030206081, 600.00, 600.00, 'Apertura de cuenta con Q500', '01/04/2024 07:00:00', 'esta apertura tiene fecha',5,1001);

-- registro de productoservicio
--                    id, tipo, costo, descripcion
CALL crearProductoServicio(18, 1, 50.80, 'Este es un servicio el cual tiene un precio predefinido'); -- servicio
CALL crearProductoServicio(19, 2, 0, 'Este es un producto el cual tiene un precio variable'); -- producto, tiene un precio de "cero" el cual indica que es variable

-- realizar compra
--              id,      fecha,   monto,  otrosdetalles, codProducto/Servicio, idcliente
CALL realizarCompra(1111, '10/04/2024', 40, 'compra de servicio', 18, 1001); -- aqui hay error ya que el monto deberia de ser cero por que ya tiene un precio preestablecido por ser un servicio
CALL realizarCompra(1112, '10/04/2024', 0, 'compra de producto', 19, 1001); -- aqui hay error debido a que el monto deberia de ser > 0 ya que es un producto y no tiene un precio preestablecido
CALL realizarCompra(1113, '10/04/2024', 50, 'compra de producto', 19, 1001); -- aqui esta correcto ya que el monto es mayor a cero y es un producto

-- realizar deposito
--              id,      fecha,     monto,  otrosdetalles, idcliente
CALL realizarDeposito(1114, '10/04/2024', 100, 'deposito de dinero', 1001);
CALL realizarDeposito(1115, '10/04/2024', 0, 'deposito de dinero', 1001); -- aqui hay error ya que el monto deberia de ser mayor a cero

-- realizar retiro
--              id,      fecha,     monto,  otrosdetalles, idcliente
CALL realizarDebito(1116, '10/04/2024', 100, 'retiro de dinero', 1001);
CALL realizarDebito(1117, '10/04/2024', 0, 'retiro de dinero con error', 1001); -- aqui hay error ya que el monto deberia de ser mayor a cero

-- tipo transaccion
-- Se van a tener 3 tipos de transacción
-- 1. compra
-- 2. deposito
-- 3. debito

-- registrar tipo de transaccion
--                  id, nombre, descripcion
CALL registrarTipoTransaccion(1, 'Compra', 'Transacción de compra');
CALL registrarTipoTransaccion(2, 'Deposito', 'Transacción de deposito');
CALL registrarTipoTransaccion(3, 'Debito', 'Transacción de debito');

-- registrar transaccion
--              id,      fecha,  otrosdetalles, id_tipo_transaccion, idcompra/deposito/debito, nocuenta
CALL asignarTransaccion(1118, '10/04/2024', '', 1, 1113, 3030206080); -- aqui hay error debido a que no se tiene el saldo suficiente para realizar la compra
CALL asignarTransaccion(1115, '10/04/2024', '', 2, 1114, 3030206080); -- se realia deposito *aqui se puede depositar a una cuenta que no es del cliente
CALL asignarTransaccion(1120, '10/04/2024', 'este si tiene detalle', 3, 1116, 3030206080); -- se realiza un debito