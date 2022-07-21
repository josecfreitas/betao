package database

type CRUDRepository[T interface{}, ID interface{}] interface {
	Find(id ID) (T, error)
	FindAll() ([]T, error)
	Create(game T) (T, error)
	Update(id ID, game T) (T, error)
}
