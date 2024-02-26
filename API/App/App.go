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
	app.Listen(":8000")
}
