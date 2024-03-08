package main

import (
	controller "P1/Controller"

	"github.com/gofiber/fiber/v2"
	"github.com/gofiber/fiber/v2/middleware/cors"
)

func main() {
	app := fiber.New()
	app.Use(cors.New())

	endpoints := controller.NewController()

	app.Get("/", endpoints.Running)
	app.Get("/test", endpoints.Test)
	app.Get("/consulta1", endpoints.Query1)
	app.Get("/consulta2", endpoints.Query2)
	app.Get("/consulta3", endpoints.Query3)
	app.Get("/consulta4", endpoints.Query4)
	app.Get("/consulta5", endpoints.Query5)
	app.Get("/consulta6", endpoints.Query6)
	app.Get("/consulta7", endpoints.Query7)
	app.Get("/consulta8", endpoints.Query8)
	app.Get("/consulta9", endpoints.Query9)
	app.Get("/consulta10", endpoints.Query10)
	app.Get("/eliminarmodelo", endpoints.Deletemodel)
	app.Get("/crearmodelo", endpoints.Createmodel)
	app.Get("/borrarinfodb", endpoints.Deleteinfo)
	app.Get("/cargarmodelo", endpoints.Postdatamodel)
	app.Listen(":8000")
}
