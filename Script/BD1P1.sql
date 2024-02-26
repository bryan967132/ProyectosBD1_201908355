CREATE DATABASE BD1P1;
USE BD1P1;

CREATE TABLE Test(
    id INT PRIMARY KEY,
    texto VARCHAR(255)
);

INSERT INTO Test(id, texto) VALUES(1, "Hola Mundo");
INSERT INTO Test(id, texto) VALUES(2, "Es Una Prueba");

SELECT * FROM Test;