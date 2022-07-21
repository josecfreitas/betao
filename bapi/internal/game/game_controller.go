package game

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

type gameController struct {
	service GameService
}

func NewGameController(service GameService) gameController {
	return gameController{service}
}

func (gc gameController) HandleRequests(r *gin.RouterGroup) {
	r.GET("/", func(c *gin.Context) {
		game, err := gc.service.findAll()

		if err != nil {
			c.JSON(http.StatusInternalServerError, gin.H{
				"message": err.Error(),
			})
			return
		}

		c.JSON(http.StatusOK, game)
	})

	r.GET("/:id", func(c *gin.Context) {
		gc.service.find(123)
		c.JSON(http.StatusOK, gin.H{
			"find": c.Param(("id")),
		})
	})

	r.POST("/", func(c *gin.Context) {
		gc.service.create(Game{})
		c.JSON(http.StatusOK, gin.H{
			"create": true,
		})
	})

	r.PUT("/:id", func(c *gin.Context) {
		gc.service.update(123, Game{})
		c.JSON(http.StatusOK, gin.H{
			"update": c.Param(("id")),
		})
	})
}
