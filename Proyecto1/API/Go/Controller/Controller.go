package controller

import (
	"database/sql"
	"encoding/csv"
	"fmt"
	"io"
	"io/ioutil"
	"log"
	"os"
	"strings"

	_ "github.com/go-sql-driver/mysql"

	"github.com/gofiber/fiber/v2"
)

type Controller struct {
	DB  *sql.DB
	err error
}

func NewController() *Controller {
	ctrl := &Controller{}
	ctrl.connect()
	return ctrl
}

func (c *Controller) connect() bool {
	c.DB, c.err = sql.Open("mysql", "root:for00nite@tcp(127.0.0.1:3306)/BD1P1")
	if c.err != nil {
		return false
	}

	c.err = c.DB.Ping()
	if c.err != nil {
		return false
	}

	c.DB.SetMaxOpenConns(100 * 1024)
	return true
}

func (c *Controller) disconnect() {
	c.DB.Close()
}

func (c *Controller) Running(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Server is running!!!",
	})
}

func (c *Controller) Query1(ctx *fiber.Ctx) error {
	query := `SELECT c.id, c.nombre, c.apellido, p.nombre AS pais, SUM(precio * cantidad) AS monto_total, sum(1) as cantidad
FROM cliente c
JOIN orden o ON c.id = o.cliente_id
JOIN datoorden do ON o.id = do.orden_id
JOIN producto pr ON do.producto_id = pr.id
JOIN vendedor v ON do.vendedor_id = v.id
JOIN pais p ON c.pais_id = p.id
GROUP BY c.id
ORDER BY monto_total DESC
LIMIT 1;`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query1 error 1",
		})
	}
	defer rows.Close()

	response := fiber.Map{}

	for rows.Next() {
		var c_id int
		var c_nombre string
		var c_apellido string
		var p_nombre string
		var monto_total float64
		var cantidad float64
		if err := rows.Scan(&c_id, &c_nombre, &c_apellido, &p_nombre, &monto_total, &cantidad); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query1 error 2",
			})
		}
		response = fiber.Map{
			"cliente":     fiber.Map{"id": c_id, "nombre": c_nombre, "apellido": c_apellido},
			"pais":        p_nombre,
			"monto total": monto_total,
			"cantidad":    cantidad,
		}
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query1",
		"descripcion": "Cliente que mas ha comprado",
		"response":    response,
	})
}

func (c *Controller) Query2(ctx *fiber.Ctx) error {
	query := `(SELECT do.producto_id, pr.nombre, cat.nombre AS categoria,
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
LIMIT 1);`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query2 error 1",
		})
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var id_producto int
		var pr_nombre string
		var cat_nombre string
		var cantidad_unidades float64
		var monto_vendido float64
		if err := rows.Scan(&id_producto, &pr_nombre, &cat_nombre, &cantidad_unidades, &monto_vendido); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query2 error 2",
			})
		}
		response = append(response, fiber.Map{
			"producto":          fiber.Map{"id": id_producto, "nombre": pr_nombre, "categoria": cat_nombre},
			"unidades vendidas": cantidad_unidades,
			"monto vendido":     monto_vendido,
		})
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query2",
		"descripcion": "Producto mas y menos comprado",
		"response":    response,
	})
}

func (c *Controller) Query3(ctx *fiber.Ctx) error {
	query := `SELECT v.id, v.nombre, v.apellido, SUM(do.cantidad * pr.precio) AS monto_total_vendido
FROM vendedor v
JOIN datoorden do ON v.id = do.vendedor_id
JOIN producto pr ON do.producto_id = pr.id
GROUP BY v.id
ORDER BY monto_total_vendido DESC
LIMIT 1;`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query3 error 1",
		})
	}
	defer rows.Close()

	var response fiber.Map

	for rows.Next() {
		var v_id int
		var v_nombre string
		var v_apellido string
		var monto_total_vendido float64
		if err := rows.Scan(&v_id, &v_nombre, &v_apellido, &monto_total_vendido); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query3 error 2",
			})
		}
		response = fiber.Map{
			"vencedor":            fiber.Map{"id": v_id, "nombre": v_nombre, "apellido": v_apellido},
			"monto total vendido": monto_total_vendido,
		}
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query3",
		"descripcion": "Persona que mas ha vendido",
		"response":    response,
	})
}

func (c *Controller) Query4(ctx *fiber.Ctx) error {
	query := `(SELECT p.nombre AS pais, SUM(pr.precio * dor.cantidad) AS monto_total
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
LIMIT 1);`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query4 error 1",
		})
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var p_nombre string
		var monto_total float64
		if err := rows.Scan(&p_nombre, &monto_total); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query4 error 2",
			})
		}
		response = append(response, fiber.Map{"pais": p_nombre, "monto total": monto_total})
	}
	return ctx.JSON(fiber.Map{
		"status":      "Query4",
		"descripcion": "Pais que mas y menos ha vendido",
		"response":    response,
	})
}

func (c *Controller) Query5(ctx *fiber.Ctx) error {
	query := `SELECT p.id, p.nombre AS pais, SUM(do.cantidad * pr.precio) AS monto_total
FROM pais p
JOIN cliente c ON p.id = c.pais_id
JOIN orden o ON c.id = o.cliente_id
JOIN datoorden do ON o.id = do.orden_id
JOIN producto pr ON do.producto_id = pr.id
GROUP BY p.id, p.nombre
ORDER BY monto_total ASC
LIMIT 5;`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query5 error 1",
		})
	}
	defer rows.Close()

	response := fiber.Map{}
	i := 1

	for rows.Next() {
		var p_id int
		var p_nombre string
		var monto_total float64
		if err := rows.Scan(&p_id, &p_nombre, &monto_total); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query5 error 2",
			})
		}
		response[fmt.Sprint(i)] = fiber.Map{
			"pais":        fiber.Map{"id": p_id, "nombre": p_nombre},
			"monto total": monto_total,
		}
		i++
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query5",
		"descripcion": "Top 5 de paises que mas han comprado en orden ascendente",
		"response":    response,
	})
}

func (c *Controller) Query6(ctx *fiber.Ctx) error {
	query := `(SELECT cat.nombre AS categoria, SUM(do.cantidad) AS cantidad_unidades
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
LIMIT 1);`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query6 error 1",
		})
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var cat_nombre string
		var cantidad_unidades float64
		if err := rows.Scan(&cat_nombre, &cantidad_unidades); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query6 error 2",
			})
		}
		response = append(response, fiber.Map{
			"categoria":          cat_nombre,
			"unidades compradas": cantidad_unidades,
		})
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query6",
		"descripcion": "Categoria que mas y menos se ha comprado",
		"response":    response,
	})
}

func (c *Controller) Query7(ctx *fiber.Ctx) error {
	query := `SELECT nombre_pais, nombre_categoria, cantidad_unidades FROM (
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
WHERE ranking = 1;`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query7 error 1",
		})
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var p_nombre string
		var cat_nombre string
		var cantidad_unidades float64
		if err := rows.Scan(&p_nombre, &cat_nombre, &cantidad_unidades); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query7 error 2",
			})
		}
		response = append(response, fiber.Map{
			"pais":               p_nombre,
			"categoria":          cat_nombre,
			"unidades compradas": cantidad_unidades,
		})
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query7",
		"descripcion": "Categoria mas comprada por cada pais",
		"response":    response,
	})
}

func (c *Controller) Query8(ctx *fiber.Ctx) error {
	query := `SELECT MONTH(o.fecha) AS mes, SUM(pr.precio * dor.cantidad) AS monto
FROM pais p
JOIN vendedor v ON v.pais_id = p.id
JOIN datoorden dor ON dor.vendedor_id = v.id
JOIN orden o ON o.id = dor.orden_id
JOIN producto pr ON pr.id = dor.producto_id
WHERE p.nombre = 'Inglaterra'
GROUP BY mes
ORDER BY mes ASC;`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query8 error 1",
		})
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var mes int
		var monto string
		if err := rows.Scan(&mes, &monto); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query8 error 2",
			})
		}
		response = append(response, fiber.Map{
			"mes":   mes,
			"monto": monto,
		})
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query8",
		"descripcion": "Ventas por mes de Inglaterra",
		"response":    response,
	})
}

func (c *Controller) Query9(ctx *fiber.Ctx) error {
	query := `(SELECT MONTH(o.fecha) AS mes, SUM(dor.cantidad * pr.precio) AS monto
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
LIMIT 1);`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query9 error 1",
		})
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var mes int
		var monto string
		if err := rows.Scan(&mes, &monto); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query9 error 2",
			})
		}
		response = append(response, fiber.Map{
			"mes":   mes,
			"monto": monto,
		})
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query9",
		"descripcion": "Mes con mas y menos ventas",
		"response":    response,
	})
}

func (c *Controller) Query10(ctx *fiber.Ctx) error {
	query := `SELECT pr.id, pr.nombre, SUM(do.cantidad * pr.precio) AS monto
FROM producto pr
JOIN datoorden do ON pr.id = do.producto_id
JOIN categoria cat ON pr.categoria_id = cat.id
WHERE cat.nombre = 'Deportes'
GROUP BY pr.id, pr.nombre;`
	rows, err := c.DB.Query(query)
	if err != nil {
		defer rows.Close()
		return ctx.JSON(fiber.Map{
			"status": "Query10 error 1",
		})
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var pr_id int
		var pr_nombre string
		var monto float64
		if err := rows.Scan(&pr_id, &pr_nombre, &monto); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query10 error 2",
			})
		}
		response = append(response, fiber.Map{
			"producto": fiber.Map{"id": pr_id, "nombre": pr_nombre},
			"monto":    monto,
		})
	}

	return ctx.JSON(fiber.Map{
		"status":      "Query10",
		"descripcion": "Ventas de cada producto de la categoria Deportes",
		"response":    response,
	})
}

func (c *Controller) Deletemodel(ctx *fiber.Ctx) error {
	script := `DROP TABLE IF EXISTS orden;
	DROP TABLE IF EXISTS datoorden;
	DROP TABLE IF EXISTS producto;
	DROP TABLE IF EXISTS vendedor;
	DROP TABLE IF EXISTS cliente;
	DROP TABLE IF EXISTS categoria;
	DROP TABLE IF EXISTS pais;`

	for _, query := range strings.Split(script, ";") {
		c.DB.Exec(query)
	}

	return ctx.JSON(fiber.Map{
		"status": "Modelo eliminado",
	})
}

func (c *Controller) Createmodel(ctx *fiber.Ctx) error {
	fileData, _ := ioutil.ReadFile("../../../Script/BD1P1.sql")

	for _, query := range strings.Split(string(fileData), ";") {
		c.DB.Exec(query)
	}

	return ctx.JSON(fiber.Map{
		"status": "Modelo creado",
	})
}

func (c *Controller) Deleteinfo(ctx *fiber.Ctx) error {
	script := `SET FOREIGN_KEY_CHECKS = 0;
	TRUNCATE TABLE orden;
	TRUNCATE TABLE datoorden;
	TRUNCATE TABLE producto;
	TRUNCATE TABLE vendedor;
	TRUNCATE TABLE cliente;
	TRUNCATE TABLE categoria;
	TRUNCATE TABLE pais;
	SET FOREIGN_KEY_CHECKS = 1;`

	for _, query := range strings.Split(script, ";") {
		c.DB.Exec(query)
	}

	return ctx.JSON(fiber.Map{
		"status": "Informacion eliminada",
	})
}

func (c *Controller) Postdatamodel(ctx *fiber.Ctx) error {
	files := []string{
		"../../../Data/paises.csv",
		"../../../Data/Categorias.csv",
		"../../../Data/clientes.csv",
		"../../../Data/vendedores.csv",
		"../../../Data/productos.csv",
		"../../../Data/ordenes.csv",
	}

	insertPais := ``
	insertCategoria := ``
	insertCliente := ``
	insertVendedor := ``
	insertProducto := ``
	insertOrden := ``
	insertDatoOrden := ``

	for i, r := range files {
		file, err := os.Open(r)
		if err != nil {
			log.Fatal(err)
		}
		defer file.Close()

		reader := csv.NewReader(file)
		reader.Comma = ';'
		header := true

		for {
			line, err := reader.Read()
			if err == io.EOF {
				break
			}
			if err != nil {
				fmt.Println("\033[96mNo se pudo leer la linea del csv\033[0m")
				continue
			}
			if header {
				header = false
				continue
			}
			if i == 0 { // Pais
				if insertPais != "" {
					insertPais += ",\n"
				}
				insertPais += fmt.Sprintf(`(%s, "%s")`, line[0], line[1])
			} else if i == 1 { // Categoria
				if insertCategoria != "" {
					insertCategoria += ",\n"
				}
				insertCategoria += fmt.Sprintf(`(%s, "%s")`, line[0], line[1])
			} else if i == 2 { // Cliente
				if insertCliente != "" {
					insertCliente += ",\n"
				}
				insertCliente += fmt.Sprintf(`(%s, "%s", "%s", "%s", "%s", "%s", %s, %s, "%s", %s)`, line[0], line[1], line[2], line[3], line[4], line[5], line[6], line[7], line[8], line[9])
			} else if i == 3 { // Vendedor
				if insertVendedor != "" {
					insertVendedor += ",\n"
				}
				fullName := strings.Split(line[1], " ")
				insertVendedor += fmt.Sprintf(`(%s, "%s", "%s", %s)`, line[0], fullName[0], fullName[1], line[2])
			} else if i == 4 { // Producto
				if insertProducto != "" {
					insertProducto += ",\n"
				}
				insertProducto += fmt.Sprintf(`(%s, "%s", %s, %s)`, line[0], line[1], line[2], line[3])
			} else { // Orden
				date := strings.Split(line[2], "/")
				line[2] = fmt.Sprintf("%s-%s-%s", date[2], date[1], date[0])
				registro := fmt.Sprintf(`(%s, '%s', %s)`, line[0], line[2], line[3])
				if !strings.Contains(insertOrden, registro) {
					if insertOrden != "" {
						insertOrden += ",\n"
					}
					insertOrden += registro
				}
				if insertDatoOrden != "" {
					insertDatoOrden += ",\n"
				}
				insertDatoOrden += fmt.Sprintf(`(%s, %s, %s, %s, %s)`, line[1], line[6], line[0], line[4], line[5])
			}
		}

		c.DB.Exec(fmt.Sprintf("INSERT INTO pais (id, nombre) VALUE\n%s", insertPais))
		c.DB.Exec(fmt.Sprintf("INSERT INTO categoria (id, nombre) VALUE\n%s", insertCategoria))
		c.DB.Exec(fmt.Sprintf("INSERT INTO cliente (id, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id) VALUE\n%s", insertCliente))
		c.DB.Exec(fmt.Sprintf("INSERT INTO vendedor (id, nombre, apellido, pais_id) VALUE\n%s", insertVendedor))
		c.DB.Exec(fmt.Sprintf("INSERT INTO producto (id, nombre, precio, categoria_id) VALUE\n%s", insertProducto))
		c.DB.Exec(fmt.Sprintf("INSERT INTO orden (id, fecha, cliente_id) VALUE\n%s", insertOrden))
		c.DB.Exec(fmt.Sprintf("INSERT INTO datoorden (linea, cantidad, orden_id, vendedor_id, producto_id) VALUE\n%s", insertDatoOrden))
	}

	return ctx.JSON(fiber.Map{
		"status": "Informacion insertada",
	})
}
