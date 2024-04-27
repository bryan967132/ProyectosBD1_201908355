# Proyecto 2 Bases 1 1S 2024

## 201908355 - Danny Hugo Bryan Tejaxún Pichiyá

## Modelos

### **Modelo Conceptual**
![Conceptual](./Models/Conceptual.svg)

### **Modelo Logico**
![Conceptual](./Models/Logical.png)

### **Modelo Relacional**
![Conceptual](./Models/Relational.png)

## Script De La Base De Datos BD1P2
```sql
CREATE TABLE IF NOT EXISTS BD1P2.TipoBien (
    id     INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoCliente (
    id          INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(40) NOT NULL,
    descripcion VARCHAR(200)
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoCuenta (
    id          INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(40) NOT NULL,
    descripcion VARCHAR(200) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.TipoTransaccion (
    id          INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    nombre      VARCHAR(20) NOT NULL,
    descripcion VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS BD1P2.Bien (
    id          INTEGER PRIMARY KEY NOT NULL,
    costo       FLOAT(2),
    descripcion VARCHAR(100),
    tipobien_id INTEGER NOT NULL,
    FOREIGN KEY (tipobien_id) REFERENCES TipoBien (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Cliente (
    id             INTEGER PRIMARY KEY NOT NULL,
    nombre         VARCHAR(40) NOT NULL,
    apellidos      VARCHAR(40) NOT NULL,
    usuario        VARCHAR(40) NOT NULL,
    contrasena     VARCHAR(200) NOT NULL,
    fechacreacion  DATE NOT NULL,
    tipocliente_id INTEGER NOT NULL,
    FOREIGN KEY (tipocliente_id) REFERENCES BD1P2.TipoCliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Telefono (
    id         INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    numero     VARCHAR(12),
    cliente_id INTEGER,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Correo (
    id         INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    direccion  VARCHAR(100),
    cliente_id INTEGER,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Cuenta (
    id             INTEGER PRIMARY KEY NOT NULL,
    monto_apertura FLOAT(2) NOT NULL,
    saldo          FLOAT(2) NOT NULL,
    descripcion    VARCHAR(255) NOT NULL,
    fecha_apertura DATE NOT NULL,
    otros_detalles VARCHAR(255),
    tipocuenta_id  INTEGER NOT NULL,
    cliente_id     INTEGER NOT NULL,
    FOREIGN KEY (tipocuenta_id) REFERENCES BD1P2.TipoCuenta (id),
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Compra (
    id             INTEGER PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    importe        FLOAT,
    otros_detalles VARCHAR(100),
    bien_id INTEGER NOT NULL,
    cliente_id INTEGER NOT NULL,
    FOREIGN KEY (bien_id) REFERENCES BD1P2.Bien (id),
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Debito (
    id             INTEGER PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    monto          FLOAT(2) NOT NULL,
    otros_detalles VARCHAR(40),
    cliente_id     INTEGER NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Deposito (
    id             INTEGER PRIMARY KEY NOT NULL,
    fecha          DATE NOT NULL,
    monto          FLOAT(2) NOT NULL,
    otros_detalles VARCHAR(40),
    cliente_id     INTEGER NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES BD1P2.Cliente (id)
);

CREATE TABLE IF NOT EXISTS BD1P2.Transaccion (
    id                 INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    fecha              DATE NOT NULL,
    otros_detalles     VARCHAR(40),
    cuenta_id          INTEGER NOT NULL,
    tipotransaccion_id INTEGER NOT NULL,
    deposito_id        INTEGER,
    debito_id          INTEGER,
    compra_id          INTEGER,
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
```

[Script del Modelo](./Script/BD1P2.sql)  
[Script de Procedimientos y Funciones](./Script/BD1P2.sql)  

## Relaciones

### Lógica Del Modelo

## Entidades

## Claves Primarias Y Foráneas

## Datos De Entrada