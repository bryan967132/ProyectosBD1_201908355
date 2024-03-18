USE BD1P1;

SELECT * FROM pais;
SELECT * FROM categoria;
SELECT * FROM cliente;
SELECT * FROM vendedor;
SELECT * FROM producto;
SELECT * FROM orden;
SELECT * FROM datoorden;

-- CONSULTA 1
SELECT c.id, c.nombre, c.apellido, p.nombre AS pais, SUM(precio * cantidad) AS monto_total, sum(1) as cantidad
FROM cliente c
JOIN orden o ON c.id = o.cliente_id
JOIN datoorden do ON o.id = do.orden_id
JOIN producto pr ON do.producto_id = pr.id
JOIN vendedor v ON do.vendedor_id = v.id
JOIN pais p ON c.pais_id = p.id
GROUP BY c.id
ORDER BY monto_total DESC
LIMIT 1;

-- CONSULTA 2
(SELECT do.producto_id, pr.nombre, cat.nombre AS categoria,
       SUM(do.cantidad) AS cantidad_unidades,
       SUM(do.cantidad * pr.precio) AS monto_vendido
FROM datoorden do
JOIN producto pr ON do.producto_id = pr.id
JOIN categoria cat ON pr.categoria_id = cat.id
GROUP BY do.producto_id
ORDER BY cantidad_unidades DESC
LIMIT 1)
UNION
(SELECT do.producto_id, pr.nombre, cat.nombre AS categoria,
       SUM(do.cantidad) AS cantidad_unidades,
       SUM(do.cantidad * pr.precio) AS monto_vendido
FROM datoorden do
JOIN producto pr ON do.producto_id = pr.id
JOIN categoria cat ON pr.categoria_id = cat.id
GROUP BY do.producto_id
ORDER BY cantidad_unidades ASC
LIMIT 1);

-- CONSULTA 3
SELECT v.id, v.nombre, v.apellido, SUM(do.cantidad * pr.precio) AS monto_total_vendido
FROM vendedor v
JOIN datoorden do ON v.id = do.vendedor_id
JOIN producto pr ON do.producto_id = pr.id
GROUP BY v.id
ORDER BY monto_total_vendido DESC
LIMIT 1;

-- CONSULTA 4
(SELECT p.nombre AS pais, SUM(pr.precio * dor.cantidad) AS monto_total
FROM pais p
JOIN vendedor v ON v.pais_id = p.id
JOIN datoorden dor ON dor.vendedor_id = v.id
JOIN producto pr ON pr.id = dor.producto_id
GROUP BY pais
ORDER BY monto_total DESC
LIMIT 1)
UNION
(SELECT p.nombre AS pais, SUM(pr.precio * dor.cantidad) AS monto_total
FROM pais p
JOIN vendedor v ON v.pais_id = p.id
JOIN datoorden dor ON dor.vendedor_id = v.id
JOIN producto pr ON pr.id = dor.producto_id
GROUP BY pais
ORDER BY monto_total ASC
LIMIT 1);

-- CONSULTA 5
SELECT p.id, p.nombre AS pais, SUM(do.cantidad * pr.precio) AS monto_total
FROM pais p
JOIN cliente c ON p.id = c.pais_id
JOIN orden o ON c.id = o.cliente_id
JOIN datoorden do ON o.id = do.orden_id
JOIN producto pr ON do.producto_id = pr.id
GROUP BY p.id, p.nombre
ORDER BY monto_total ASC
LIMIT 5;

-- CONSULTA 6
(SELECT cat.nombre AS categoria, SUM(do.cantidad) AS cantidad_unidades
FROM categoria cat
JOIN producto pr ON cat.id = pr.categoria_id
JOIN datoorden do ON pr.id = do.producto_id
GROUP BY cat.nombre
ORDER BY cantidad_unidades DESC
LIMIT 1)
UNION
(SELECT cat.nombre AS categoria, SUM(do.cantidad) AS cantidad_unidades
FROM categoria cat
JOIN producto pr ON cat.id = pr.categoria_id
JOIN datoorden do ON pr.id = do.producto_id
GROUP BY cat.nombre
ORDER BY cantidad_unidades ASC
LIMIT 1);

-- CONSULTA 7
SELECT nombre_pais, nombre_categoria, cantidad_unidades FROM (
    SELECT 
        p.nombre AS nombre_pais,
        cat.nombre AS nombre_categoria,
        SUM(d.cantidad) AS cantidad_unidades,
        ROW_NUMBER() OVER(PARTITION BY p.nombre ORDER BY SUM(d.cantidad) DESC) AS ranking
    FROM pais p
    JOIN cliente c ON p.id = c.pais_id
    JOIN orden o ON c.id = o.cliente_id
    JOIN datoorden d ON o.id = d.orden_id
    JOIN producto pr ON d.producto_id = pr.id
    JOIN categoria cat ON pr.categoria_id = cat.id
    GROUP BY p.nombre, cat.nombre
) t
WHERE ranking = 1;

-- CONSULTA 8
SELECT MONTH(o.fecha) AS mes, SUM(pr.precio * dor.cantidad) AS monto
FROM pais p
JOIN vendedor v ON v.pais_id = p.id
JOIN datoorden dor ON dor.vendedor_id = v.id
JOIN orden o ON o.id = dor.orden_id
JOIN producto pr ON pr.id = dor.producto_id
WHERE p.nombre = 'Inglaterra'
GROUP BY mes
ORDER BY mes ASC;

-- CONSULTA 9
(SELECT MONTH(o.fecha) AS mes, SUM(dor.cantidad * pr.precio) AS monto
FROM orden o
JOIN datoorden dor ON dor.orden_id = o.id
JOIN producto pr ON pr.id = dor.producto_id
GROUP BY mes
ORDER BY monto DESC
LIMIT 1)
UNION
(SELECT MONTH(o.fecha) AS mes, SUM(dor.cantidad * pr.precio) AS monto
FROM orden o
JOIN datoorden dor ON dor.orden_id = o.id
JOIN producto pr ON pr.id = dor.producto_id
GROUP BY mes
ORDER BY monto ASC
LIMIT 1);

-- CONSULTA 10
SELECT pr.id, pr.nombre, SUM(do.cantidad * pr.precio) AS monto
FROM producto pr
JOIN datoorden do ON pr.id = do.producto_id
JOIN categoria cat ON pr.categoria_id = cat.id
WHERE cat.nombre = 'Deportes'
GROUP BY pr.id, pr.nombre;