package main

import (
	"github.com/gin-gonic/gin"
	"github.com/josecfreitas/betao/bapi/internal/game"
)

func handleRequests() {
	r := gin.Default()

	gameRepository := game.NewGameRepository()
	gameService := game.NewGameService(gameRepository)
	gameController := game.NewGameController(gameService)
	gameController.HandleRequests(r.Group("games"))

	r.Run(":3000")
}

func main() {
	handleRequests()
}
