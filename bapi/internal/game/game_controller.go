package game

import (
	"net/http"

	"github.com/gin-gonic/gin"
)

func GameController(r *gin.RouterGroup) {
	r.GET("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"list": true,
		})
	})

	r.GET("/:id", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"find": c.Param(("id")),
		})
	})

	r.POST("/", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"create": true,
		})
	})

	r.PUT("/:id", func(c *gin.Context) {
		c.JSON(http.StatusOK, gin.H{
			"update": c.Param(("id")),
		})
	})
}
