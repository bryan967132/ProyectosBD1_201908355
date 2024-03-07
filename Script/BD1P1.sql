CREATE DATABASE BD1P1;
USE BD1P1;

CREATE TABLE Test(
    id INT PRIMARY KEY,
    texto VARCHAR(255)
);

INSERT INTO Test(id, texto) VALUES(1, "Hola Mundo");
INSERT INTO Test(id, texto) VALUES(2, "Es Una Prueba");

SELECT * FROM Test;

CREATE TABLE categoria (
    id     INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

ALTER TABLE categoria ADD CONSTRAINT categoria_pk PRIMARY KEY ( id );

CREATE TABLE cliente (
    id        INTEGER NOT NULL,
    nombre    VARCHAR(100) NOT NULL,
    apellido  VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono  VARCHAR(8) NOT NULL,
    tarjeta   VARCHAR(255) NOT NULL,
    edad      INTEGER NOT NULL,
    salario   FLOAT(2) NOT NULL,
    genero    CHAR(1) NOT NULL,
    pais_id   INTEGER NOT NULL
);

ALTER TABLE cliente ADD CONSTRAINT cliente_pk PRIMARY KEY ( id );

CREATE TABLE orden (
    id          INTEGER NOT NULL,
    linea       INTEGER NOT NULL,
    fecha       DATE NOT NULL,
    cantidad    INTEGER NOT NULL,
    cliente_id  INTEGER NOT NULL,
    vendedor_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL
);

ALTER TABLE orden ADD CONSTRAINT orden_pk PRIMARY KEY ( id );

CREATE TABLE pais (
    id     INTEGER NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

ALTER TABLE pais ADD CONSTRAINT pais_pk PRIMARY KEY ( id );

CREATE TABLE producto (
    id           INTEGER NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    precio       FLOAT(2) NOT NULL,
    categoria_id INTEGER NOT NULL
);

ALTER TABLE producto ADD CONSTRAINT producto_pk PRIMARY KEY ( id );

CREATE TABLE vendedor (
    id       INTEGER NOT NULL,
    nombre   VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL
);

ALTER TABLE vendedor ADD CONSTRAINT vendedor_pk PRIMARY KEY ( id );

ALTER TABLE cliente
    ADD CONSTRAINT cliente_pais_fk FOREIGN KEY ( pais_id )
        REFERENCES pais ( id );

ALTER TABLE orden
    ADD CONSTRAINT orden_cliente_fk FOREIGN KEY ( cliente_id )
        REFERENCES cliente ( id );

ALTER TABLE orden
    ADD CONSTRAINT orden_producto_fk FOREIGN KEY ( producto_id )
        REFERENCES producto ( id );

ALTER TABLE orden
    ADD CONSTRAINT orden_vendedor_fk FOREIGN KEY ( vendedor_id )
        REFERENCES vendedor ( id );

ALTER TABLE producto
    ADD CONSTRAINT producto_categoria_fk FOREIGN KEY ( categoria_id )
        REFERENCES categoria ( id );