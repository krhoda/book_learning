package cmd

import (
	"fmt"

	"github.com/krhoda/little-book-of-channels/chapter"
	"github.com/krhoda/little-book-of-channels/puzzle"
)

var (
	puzzleMap = map[int][]puzzle.Record{
		1: chapter.Chapter1,
		3: chapter.Chapter3,
		4: chapter.Chapter4,
	}
)

func runAllPuzzles() {
	for chapter, puzzleSlice := range puzzleMap {
		fmt.Printf("Chapter %d Exercises:\n", chapter)
		for _, puzz := range puzzleSlice {
			puzz.PrintPuzzle()
		}
	}
}

func listAllPuzzles() {
	for chapter, puzzleSlice := range puzzleMap {
		fmt.Printf("Chapter %d Exercises:\n", chapter)
		for _, puzz := range puzzleSlice {
			puzz.PrintQuestion()
		}
	}
}

func listChapterPuzzles(chapter int) error {
	target, err := checkForChapter(chapter)
	if err != nil {
		return err
	}

	for _, puzzleRec := range target {
		puzzleRec.PrintQuestion()
	}

	return nil
}

func runChapterPuzzles(chapter int) error {
	target, err := checkForChapter(chapter)
	if err != nil {
		return err
	}

	for _, puzzleRec := range target {
		puzzleRec.PrintPuzzle()
	}

	return nil
}

func runSpecificPuzzle(chapter, puzzleNo int) error {
	target, err := checkForChapter(chapter)
	if err != nil {
		return err
	}

	puzzleIndex := puzzleNo - 1
	puzzleTarget, err := checkForPuzzle(target, puzzleIndex)
	if err != nil {
		return err
	}

	puzzleTarget.PrintPuzzle()
	return nil
}

func listSpecificPuzzle(chapter, puzzleNo int) error {
	target, err := checkForChapter(chapter)
	if err != nil {
		return err
	}

	puzzleIndex := puzzleNo - 1
	puzzleTarget, err := checkForPuzzle(target, puzzleIndex)
	if err != nil {
		return err
	}

	puzzleTarget.PrintQuestion()
	return nil
}

func checkForPuzzle(chapterRecords []puzzle.Record, targetIndex int) (puzzle.Record, error) {
	if targetIndex >= (len(chapterRecords)) {
		err := fmt.Errorf("Tried to use non-existant puzzle, this chapter has %d puzzles.", len(chapterRecords))
		return puzzle.Record{}, err
	}

	target := chapterRecords[targetIndex]
	return target, nil
}

func checkForChapter(chapter int) ([]puzzle.Record, error) {
	target, ok := puzzleMap[chapter]
	if !ok {
		errMsg := fmt.Sprintf("Cannot find chapter %d, there are puzzles for:\n", chapter)
		for k := range puzzleMap {
			errMsg += fmt.Sprintf("Chapter %d\n", k)
		}
		errMsg += "Please try one of them!"
		err := fmt.Errorf(errMsg)

		return []puzzle.Record{}, err
	}

	return target, nil
}
