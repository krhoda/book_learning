package chapter

import (
	"fmt"

	"github.com/krhoda/little-book-of-channels/puzzle"
)

var (
	Chapter4 = []puzzle.Record{
		{
			ChapVerse: "4.1",
			QType:     "Puzzle",
			Number:    1,
			Question:  "Model the Producer / Consumer Synchronization",
			Demo:      genEvents,
			Conclude:  func() {},
		},
	}
)

func genEvents() {
	mockUI := make(chan bool)
	genChan1, genChan2 := make(chan interface{}), make(chan interface{})

	// UI Worker
	go func() {
		for {
			x := <-mockUI
			if x {
				fmt.Println("Event 1 is next.")
				genChan1 <- nil
			} else {
				fmt.Println("Event 2 is next.")
				genChan2 <- nil
			}
		}
	}()

	// Event Hanlder
	go func() {
		for {
			select {
			case <-genChan1:
				fmt.Println("Event 1 heard!")
			case <-genChan2:
				fmt.Println("Event 2 heard!")
			}
			puzzleWG.Done()
		}
	}()

	tNum, fNum := 3, 4
	puzzleWG.Add((tNum + fNum) * 2)

	// Random events:
	go func() {
		for i := 0; i < tNum; i++ {
			go func() {
				mockUI <- true
				puzzleWG.Done()
			}()
		}
	}()

	// Random events continued:
	go func() {
		for i := 0; i < fNum; i++ {
			go func() {
				mockUI <- false
				puzzleWG.Done()
			}()
		}
	}()

	puzzleWG.Wait()
}
