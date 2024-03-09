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
	c.DB, c.err = sql.Open("mysql", fmt.Sprintf("%v:%v@tcp(%v)/%v", os.Getenv("DB_USER"), os.Getenv("DB_PASS"), os.Getenv("DB_HOST"), os.Getenv("DB_NAME")))
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
	return ctx.JSON(fiber.Map{
		"status": "Query1",
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
	fileData, _ := ioutil.ReadFile("../../Script/BD1P1.sql")

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
		"../../Data/paises.csv",
		"../../Data/Categorias.csv",
		"../../Data/clientes.csv",
		"../../Data/vendedores.csv",
		"../../Data/productos.csv",
		"../../Data/ordenes.csv",
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
				_, err := c.DB.Query("INSERT INTO pais (id, nombre) VALUE (?, ?)", line[0], line[1])
				if err != nil {
					fmt.Println("Error al insertar pais", err)
				}
			} else if i == 1 { // Categoria
				_, err := c.DB.Query("INSERT INTO categoria (id, nombre) VALUE (?, ?)", line[0], line[1])
				if err != nil {
					fmt.Println("Error al insertar categoria", err)
				}
			} else if i == 2 { // Cliente
				_, err := c.DB.Query("INSERT INTO cliente (id, nombre, apellido, direccion, telefono, tarjeta, edad, salario, genero, pais_id) VALUE (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)", line[0], line[1], line[2], line[3], line[4], line[5], line[6], line[7], line[8], line[9])
				if err != nil {
					fmt.Println("Error al insertar cliente", err)
				}
			} else if i == 3 { // Vendedor
				fullName := strings.Split(line[1], " ")
				_, err := c.DB.Query("INSERT INTO vendedor (id, nombre, apellido, pais_id) VALUE (?, ?, ?, ?)", line[0], fullName[0], fullName[1], line[2])
				if err != nil {
					fmt.Println("Error al insertar vendedor", err)
				}
			} else if i == 4 { // Producto
				_, err := c.DB.Query("INSERT INTO producto (id, nombre, precio, categoria_id) VALUE (?, ?, ?, ?)", line[0], line[1], line[2], line[3])
				if err != nil {
					fmt.Println("Error al insertar producto", err)
				}
			} else { // Orden
				date := strings.Split(line[2], "/")
				line[2] = fmt.Sprintf("%s-%s-%s", date[2], date[1], date[0])
				_, err := c.DB.Query("INSERT INTO orden (id, linea, fecha, cantidad, cliente_id, vendedor_id, producto_id) VALUE (?, ?, ?, ?, ?, ?, ?)", line[0], line[1], line[2], line[6], line[3], line[4], line[5])
				if err != nil {
					fmt.Println("Error al insertar orden", err)
				}
			}
		}
	}

	return ctx.JSON(fiber.Map{
		"status": "Informacion insertada",
	})
}