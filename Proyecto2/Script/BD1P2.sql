DROP DATABASE IF EXISTS BD1P2;

CREATE DATABASE IF NOT EXISTS BD1P2;

CREATE TABLE IF NOT EXISTS BD1P2.TipoBien (
    id     BIGINT PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoCliente (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(40) NOT NULL,
    descripcion VARCHAR(255)
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoCuenta (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(40) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoTransaccion (
    id          BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(20) NOT NULL,
    descripcion VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.Bien (
    id          BIGINT PRIMARY KEY NOT NULL,
    costo       FLOAT(2),
    descripcion VARCHAR(255),
    tipobien_id BIGINT NOT NULL,
    FOREIGN KEY (tipobien_id) REFERENCES BD1P2.TipoBien (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Cliente (
    id             BIGINT PRIMARY KEY NOT NULL,
    nombre         VARCHAR(40) NOT NULL,
    apellidos      VARCHAR(40) NOT NULL,
    usuario        VARCHAR(40) NOT NULL,
    contrasena     VARCHAR(255) NOT NULL,
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
    direccion  VARCHAR(255),
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
    otros_detalles VARCHAR(255),
    bien_id BIGINT NOT NULL,
    cliente_id BIGINT NOT NULL,
    FOREIGN KEY (bien_id) REFERENCES BD1P2.Bien (id),
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Debito (
    id             BIGINT PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    monto          FLOAT(2) NOT NULL,
    otros_detalles VARCHAR(255),
    cliente_id     BIGINT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Deposito (
    id             BIGINT PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    monto          FLOAT(2) NOT NULL,
    otros_detalles VARCHAR(255),
    cliente_id     BIGINT NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Transaccion (
    id                 BIGINT PRIMARY KEY AUTO_INCREMENT NOT NULL,
    fecha              DATE NOT NULL,
    otros_detalles     VARCHAR(255),
    cuenta_id          BIGINT NOT NULL,
    tipotransaccion_id BIGINT NOT NULL,
    deposito_id        BIGINT,
    debito_id          BIGINT,
    compra_id          BIGINT,
    FOREIGN KEY (cuenta_id) REFERENCES BD1P2.Cuenta (id),
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