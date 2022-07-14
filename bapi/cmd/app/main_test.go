package main

import "testing"

func TestMain(t *testing.T) {
	t.Parallel()

	t.Run("Should run without errors", func(t *testing.T) {
		t.Parallel()

		main()
	})
}
