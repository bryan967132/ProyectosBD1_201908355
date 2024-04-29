CALL BD1P2.consultarSaldoCliente(20250001); -- Q1289.20
CALL BD1P2.consultarSaldoCliente(20250002); -- Q4654.95
CALL BD1P2.consultarSaldoCliente(20250003); 
CALL BD1P2.consultarSaldoCliente(20250004);
CALL BD1P2.consultarSaldoCliente(20250006);

CALL BD1P2.consultarCliente(202401);
CALL BD1P2.consultarCliente(202402);
CALL BD1P2.consultarCliente(202403);
CALL BD1P2.consultarCliente(202404);

CALL BD1P2.consultarMovsCliente(202401);
CALL BD1P2.consultarMovsCliente(202402);
CALL BD1P2.consultarMovsCliente(202403);
CALL BD1P2.consultarMovsCliente(202404);

CALL BD1P2.consultarTipoCuentas(1); -- 2
CALL BD1P2.consultarTipoCuentas(5);

CALL BD1P2.consultarMovsGenFech('01/01/2024','08/08/2024');

CALL BD1P2.consultarMovsFechClien(202401,'01/01/2020','12/12/2024');
CALL BD1P2.consultarMovsFechClien(202402,'01/01/2020','12/12/2024');
CALL BD1P2.consultarMovsFechClien(202403,'01/01/2020','12/12/2024');
CALL BD1P2.consultarMovsFechClien(202404,'01/01/2020','12/12/2024');

CALL BD1P2.consultarProductoServicio();