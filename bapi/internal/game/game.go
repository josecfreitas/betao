package game

import "time"

type Game struct {
	Name                       string
	BetPrice                   float64
	StartsAt                   time.Time
	EndsAt                     time.Time
	SellerCommissionPercentage int
	SystemCommisionPercentage  int
}

func (g Game) PrizePercentage() int {
	return 100 - g.SellerCommissionPercentage - g.SystemCommisionPercentage
}
