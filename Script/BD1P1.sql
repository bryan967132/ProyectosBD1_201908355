CREATE DATABASE IF NOT EXISTS BD1P1;
USE BD1P1;

CREATE TABLE IF NOT EXISTS pais (
    id     INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS categoria (
    id     INTEGER PRIMARY KEY NOT NULL,
    nombre VARCHAR(100) NOT NULL
);

CREATE TABLE IF NOT EXISTS cliente (
    id        INTEGER PRIMARY KEY NOT NULL,
    nombre    VARCHAR(100) NOT NULL,
    apellido  VARCHAR(100) NOT NULL,
    direccion VARCHAR(255) NOT NULL,
    telefono  VARCHAR(10) NOT NULL,
    tarjeta   VARCHAR(16) NOT NULL,
    edad      INTEGER NOT NULL,
    salario   FLOAT(2) NOT NULL,
    genero    CHAR(1) NOT NULL,
    pais_id   INTEGER NOT NULL,
    FOREIGN KEY (pais_id) REFERENCES pais(id)
);

CREATE TABLE IF NOT EXISTS orden (
	id          INTEGER PRIMARY KEY NOT NULL,
    fecha       DATE NOT NULL,
	cliente_id  INTEGER NOT NULL,
    FOREIGN KEY (cliente_id) REFERENCES cliente(id)
);

CREATE TABLE IF NOT EXISTS vendedor (
    id       INTEGER PRIMARY KEY NOT NULL,
    nombre   VARCHAR(100) NOT NULL,
    apellido VARCHAR(100) NOT NULL,
    pais_id  INTEGER NOT NULL,
    FOREIGN KEY (pais_id) REFERENCES pais(id)
);

CREATE TABLE IF NOT EXISTS producto (
    id           INTEGER PRIMARY KEY NOT NULL,
    nombre       VARCHAR(100) NOT NULL,
    precio       FLOAT(2) NOT NULL,
    categoria_id INTEGER NOT NULL,
    FOREIGN KEY (categoria_id) REFERENCES categoria(id)
);

CREATE TABLE IF NOT EXISTS datoorden (
	id          INTEGER PRIMARY KEY AUTO_INCREMENT NOT NULL,
    linea       INTEGER NOT NULL,
    cantidad    INTEGER NOT NULL,
    orden_id    INTEGER NOT NULL,
    vendedor_id INTEGER NOT NULL,
    producto_id INTEGER NOT NULL,
    FOREIGN KEY (orden_id) REFERENCES orden(id),
    FOREIGN KEY (vendedor_id) REFERENCES vendedor(id),
    FOREIGN KEY (producto_id) REFERENCES producto(id)
);