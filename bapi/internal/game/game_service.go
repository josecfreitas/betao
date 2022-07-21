package game

type GameService interface {
	find(id int) ([]Game, error)
	findAll() (Game, error)
	create(game Game) (Game, error)
	update(id int, game Game) (Game, error)
}

type gameService struct {
	repository GameRepository
}

func NewGameService(repository GameRepository) gameService {
	return gameService{repository}
}

func (gs gameService) find(id int) ([]Game, error) {
	return gs.repository.FindAll()
}

func (gs gameService) findAll() (Game, error) {
	return gs.repository.Find(123)
}

func (gs gameService) create(game Game) (Game, error) {
	return gs.repository.Create(game)
}

func (gs gameService) update(id int, game Game) (Game, error) {
	return gs.repository.Update(id, game)
}
