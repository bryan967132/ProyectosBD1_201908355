package controller

import (
	"database/sql"
	"log"

	_ "github.com/go-sql-driver/mysql"

	"github.com/gofiber/fiber/v2"
)

type Controller struct {
	DB  *sql.DB
	err error
}

func NewController() *Controller {
	ctrl := &Controller{}

	ctrl.DB, ctrl.err = sql.Open("mysql", "root:for00nite@tcp(127.0.0.1:3306)/BD1P1")
	if ctrl.err != nil {
		log.Fatal(ctrl.err)
	}

	ctrl.err = ctrl.DB.Ping()
	if ctrl.err != nil {
		log.Fatal(ctrl.err)
	}

	return ctrl
}

func (c *Controller) Running(ctx *fiber.Ctx) error {
	return ctx.JSON(fiber.Map{
		"status": "Interpreter is running!!!",
	})
}

func (c *Controller) Test(ctx *fiber.Ctx) error {
	rows, err := c.DB.Query("SELECT * FROM Test")
	if err != nil {
		log.Fatal(err)
	}
	defer rows.Close()

	response := []fiber.Map{}

	for rows.Next() {
		var id int
		var texto string
		if err := rows.Scan(&id, &texto); err != nil {
			log.Fatal(err)
		}
		response = append(response, fiber.Map{"id": id, "texto": texto})
	}
	if err := rows.Err(); err != nil {
		log.Fatal(err)
	}
	return ctx.JSON(fiber.Map{
		"status":   "Finish Test",
		"response": response,
	})
}
