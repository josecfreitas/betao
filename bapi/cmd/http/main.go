package main

import (
	"github.com/gin-gonic/gin"
	"github.com/josecfreitas/betao/bapi/internal/game"
)

func handleRequests() {
	r := gin.Default()

	game.GameController(r.Group("games"))

	r.Run(":3000")
}

func main() {
	handleRequests()
}
