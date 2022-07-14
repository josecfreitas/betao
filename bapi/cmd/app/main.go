package main

import (
	"fmt"
	"os"
)

func run() error {
	fmt.Println("running the app")
	return nil
}

func main() {
	if err := run(); err != nil {
		os.Exit(1)
	}
}
