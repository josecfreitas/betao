package game

import (
	"testing"
	"time"

	"github.com/stretchr/testify/assert"
)

func TestGame(t *testing.T) {
	t.Parallel()

	t.Run("PrizePercentage", func(t *testing.T) {
		t.Parallel()

		game := Game{
			Name:                       "Test",
			BetPrice:                   10.50,
			StartsAt:                   time.Now().Add(-time.Second * 1),
			EndsAt:                     time.Now().Add(time.Second * 1),
			SellerCommissionPercentage: 10,
			SystemCommisionPercentage:  5,
		}

		prizePercentage := game.PrizePercentage()

		assert.Equal(t, prizePercentage, 85, "Prize percentage incorrect")
	})

}
