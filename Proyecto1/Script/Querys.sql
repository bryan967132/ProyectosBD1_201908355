DROP TABLE IF EXISTS orden;
DROP TABLE IF EXISTS datoorden;
DROP TABLE IF EXISTS producto;
DROP TABLE IF EXISTS vendedor;
DROP TABLE IF EXISTS cliente;
DROP TABLE IF EXISTS categoria;
DROP TABLE IF EXISTS pais;

SET FOREIGN_KEY_CHECKS = 0;
TRUNCATE TABLE orden;
TRUNCATE TABLE datoorden;
TRUNCATE TABLE producto;
TRUNCATE TABLE vendedor;
TRUNCATE TABLE cliente;
TRUNCATE TABLE categoria;
TRUNCATE TABLE pais;
SET FOREIGN_KEY_CHECKS = 1;