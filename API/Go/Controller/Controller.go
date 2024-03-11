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
	query := `SELECT c.id, c.nombre, c.apellido, p.nombre AS pais, SUM(precio * cantidad) AS monto_total
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
		if err := rows.Scan(&c_id, &c_nombre, &c_apellido, &p_nombre, &monto_total); err != nil {
			return ctx.JSON(fiber.Map{
				"status": "Query1 error 2",
			})
		}
		response = fiber.Map{
			"cliente":     fiber.Map{"id": c_id, "nombre": c_nombre, "apellido": c_apellido},
			"pais":        p_nombre,
			"monto total": monto_total,
		}
	}

	return ctx.JSON(fiber.Map{
		"status":   "Query1",
		"response": response,
	})
}

func (c *Controller) Query2(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query2",
	})
}

func (c *Controller) Query3(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query3",
	})
}

func (c *Controller) Query4(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query4",
	})
}

func (c *Controller) Query5(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query5",
	})
}

func (c *Controller) Query6(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query6",
	})
}

func (c *Controller) Query7(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query7",
	})
}

func (c *Controller) Query8(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query8",
	})
}

func (c *Controller) Query9(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query9",
	})
}

func (c *Controller) Query10(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Query10",
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
				c.DB.Exec(fmt.Sprintf(`INSERT INTO pais (id, nombre) VALUE (%s, "%s")`, line[0], line[1]))
			} else if i == 1 { // Categoria
				c.DB.Exec(fmt.Sprintf(`INSERT INTO categoria (id, nombre) VALUE (%s, "%s")`, line[0], line[1]))
			} else if i == 2 { // Cliente
				c.DB.Exec(fmt.Sprintf(`INSERT INTO cliente (id, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id) VALUE (%s, "%s", "%s", "%s", "%s", "%s", %s, %s, "%s", %s)`, line[0], line[1], line[2], line[3], line[4], line[5], line[6], line[7], line[8], line[9]))
			} else if i == 3 { // Vendedor
				fullName := strings.Split(line[1], " ")
				c.DB.Exec(fmt.Sprintf(`INSERT INTO vendedor (id, nombre, apellido, pais_id) VALUE (%s, "%s", "%s", %s)`, line[0], fullName[0], fullName[1], line[2]))
			} else if i == 4 { // Producto
				c.DB.Exec(fmt.Sprintf(`INSERT INTO producto (id, nombre, precio, categoria_id) VALUE (%s, "%s", %s, %s)`, line[0], line[1], line[2], line[3]))
			} else { // Orden
				date := strings.Split(line[2], "/")
				line[2] = fmt.Sprintf("%s-%s-%s", date[2], date[1], date[0])
				c.DB.Exec(fmt.Sprintf(`INSERT INTO orden (id, fecha, cliente_id) VALUE (%s, '%s', %s)`, line[0], line[2], line[3]))
				c.DB.Exec(fmt.Sprintf(`INSERT INTO datoorden (linea, cantidad, orden_id, vendedor_id, producto_id) VALUE (%s, %s, %s, %s, %s)`, line[1], line[6], line[0], line[4], line[5]))
			}
		}
	}

	return ctx.JSON(fiber.Map{
		"status": "Informacion insertada",
	})
}
