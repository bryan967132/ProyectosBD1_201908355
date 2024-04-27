DROP DATABASE IF EXISTS BD1P2;

CREATE DATABASE IF NOT EXISTS BD1P2;

CREATE TABLE IF NOT EXISTS BD1P2.TipoBien (
    id     BIGINT PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoCliente (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(40) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoCuenta (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(40) NOT NULL,
    descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoTransaccion (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(20) NOT NULL,
    descripcion VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.Bien (
    id          BIGINT PRIMARY KEY NOT NULL,
    costo       FLOAT(2),
    descripcion VARCHAR(100),
    tipobien_id BIGINT NOT NULL,
    FOREIGN KEY (tipobien_id) REFERENCES TipoBien (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Cliente (
    id             BIGINT PRIMARY KEY NOT NULL,
    nombre         VARCHAR(40) NOT NULL,
    apellidos      VARCHAR(40) NOT NULL,
    usuario        VARCHAR(40) NOT NULL,
    contrasena     VARCHAR(200) NOT NULL,
    fechacreacion  DATE NOT NULL,
    tipocliente_id BIGINT NOT NULL,
    FOREIGN KEY (tipocliente_id) REFERENCES BD1P2.TipoCliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Telefono (
	id         BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    numero     VARCHAR(12),
    cliente_id BIGINT,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Correo (
	id         BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    direccion  VARCHAR(100),
    cliente_id BIGINT,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Cuenta (
    id             BIGINT PRIMARY KEY NOT NULL,
    monto_apertura FLOAT(2) NOT NULL,
    saldo          FLOAT(2) NOT NULL,
    descripcion    VARCHAR(255) NOT NULL,
    fecha_apertura DATETIME NOT NULL,
    otros_detalles VARCHAR(255),
    tipocuenta_id  BIGINT NOT NULL,
    cliente_id     BIGINT NOT NULL,
    FOREIGN KEY (tipocuenta_id) REFERENCES BD1P2.TipoCuenta (id),
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Compra (
    id             BIGINT PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    importe        FLOAT,
    otros_detalles VARCHAR(100),
    bien_id BIGINT NOT NULL,
    cliente_id BIGINT NOT NULL,
    FOREIGN KEY (bien_id) REFERENCES BD1P2.Bien (id),
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Debito (
    id             BIGINT PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    monto          FLOAT(2) NOT NULL,
    otros_detalles VARCHAR(40),
    cliente_id     BIGINT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Deposito (
    id             BIGINT PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    monto          FLOAT(2) NOT NULL,
    otros_detalles VARCHAR(40),
    cliente_id     BIGINT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Transaccion (
    id                 BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    fecha              DATE NOT NULL,
    otros_detalles     VARCHAR(40),
    cuenta_id          BIGINT NOT NULL,
    tipotransaccion_id BIGINT NOT NULL,
    deposito_id        BIGINT,
    debito_id          BIGINT,
    compra_id          BIGINT,
    FOREIGN KEY (cuenta_id) REFERENCES Cuenta (id),
    FOREIGN KEY (tipotransaccion_id) REFERENCES BD1P2.TipoTransaccion (id),
    FOREIGN KEY (deposito_id) REFERENCES BD1P2.Deposito (id),
    FOREIGN KEY (debito_id) REFERENCES BD1P2.Debito (id),
    FOREIGN KEY (compra_id) REFERENCES BD1P2.Compra (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Historial (
	fecha       DATETIME NOT NULL,
    descripcion VARCHAR(100),
    tipo        VARCHAR(50)
);

INSERT INTO BD1P2.TipoCliente (nombre, descripcion) VALUES
('Individual Nacional', 'Este tipo de cliente es una persona individual de nacionalidad guatemalteca.'),
('Individual Extranjero', 'Este tipo de cliente es una persona individual de nacionalidad extranjera.'),
('Empresa PyMe', 'Este tipo de cliente es una empresa de tipo pequeña o mediana.'),
('Empresa S.C', 'Este tipo de cliente corresponde a las empresa grandes que tienen una sociedad colectiva.');

INSERT INTO BD1P2.TipoCuenta (nombre, descripcion) VALUES
('Cuenta de Cheques', 'Este tipo de cuenta ofrece la facilidad de emitir cheques para realizar transacciones monetarias.'),
('Cuenta de Ahorros', 'Esta cuenta genera un interés anual del 2%, lo que la hace ideal para guardar fondos a largo plazo.'),
('Cuenta de Ahorro Plus', 'Con una tasa de interés anual del 10%, esta cuenta de ahorros ofrece mayores rendimientos.'),
('Pequeña Cuenta', 'Una cuenta de ahorros con un interés semestral del 0.5%, ideal para pequeños ahorros y movimientos.'),
('Cuenta de Nómina', 'Diseñada para recibir depósitos de sueldo y realizar pagos, con acceso a servicios bancarios básicos.'),
('Cuenta de Inversión', 'Orientada a inversionistas, ofrece opciones de inversión y rendimientos más altos que una cuenta de ahorros estándar.');

INSERT INTO BD1P2.TipoTransaccion (id, nombre, descripcion) VALUES
(1, 'Compra', 'Transacción de compra'),
(2, 'Deposito', 'Transacción de deposito'),
(3, 'Debito', 'Transacción de debito');

INSERT INTO BD1P2.TipoBien (id, nombre) VALUES
(1, 'Servicio'),
(2, 'Producto');

INSERT INTO BD1P2.Bien (id, costo, descripcion, tipobien_id) VALUES
(1, 10.00, 'Servicio de tarjeta de debito', 1),
(2, 10.00, 'Servicio de chequera', 1),
(3, 400.00, 'Servicio de asesoramiento financiero', 1),
(4, 5.00, 'Servicio de banca personal', 1),
(5, 30.00, 'Seguro de vida', 1),
(6, 100.00, 'Seguro de vida plus', 1),
(7, 300.00, 'Seguro de automóvil', 1),
(8, 500.00, 'Seguro de automóvil plus', 1),
(9, 0.05, 'Servicio de deposito', 1),
(10, 0.10, 'Servicio de Debito', 1),
(11, 0, 'Pago de energía Eléctrica (EEGSA)', 2),
(12, 0, 'Pago de agua potable (Empagua)', 2),
(13, 0, 'Pago de Matricula USAC', 2),
(14, 0, 'Pago de curso vacaciones USAC', 2),
(15, 0, 'Pago de servicio de internet', 2),
(16, 0, 'Servicio de suscripción plataformas streaming', 2),
(17, 0, 'Servicios Cloud', 2);