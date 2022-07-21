package game

import (
	"github.com/josecfreitas/betao/bapi/internal/database"
)

type GameRepository interface {
	database.CRUDRepository[Game, int]
}

type gameRepository struct{}

func NewGameRepository() gameRepository {
	return gameRepository{}
}

func (gr gameRepository) Find(id int) (Game, error) {
	return Game{}, nil
}

func (gr gameRepository) FindAll() ([]Game, error) {
	return []Game{}, nil
}

func (gr gameRepository) Create(game Game) (Game, error) {
	return game, nil
}

func (gr gameRepository) Update(id int, game Game) (Game, error) {
	return game, nil
}
