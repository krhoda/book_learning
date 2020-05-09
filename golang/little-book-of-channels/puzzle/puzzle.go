package puzzle

import (
	"fmt"

	"github.com/logrusorgru/aurora"
)

var au = aurora.NewAurora(true)

func PrintHeader(hs string) {
	fmt.Println(au.BrightBlue(hs))
}

func PrintQuestion(qs string) {
	fmt.Println(au.Cyan(qs))
}

func PrintExercise(es string) {
	fmt.Println(au.Green(es))
}

type Record struct {
	ChapVerse string
	Question  string
	QType     string
	Number    int
	Demo      func()
	Conclude  func()
}

func (p Record) PrintQuestion() {
	PrintQuestion(fmt.Sprintf("Chapter %s, %s %d: %s\n", p.ChapVerse, p.QType, p.Number, p.Question))
}
func (p Record) PrintPuzzle() {
	p.PrintQuestion()
	p.Demo()
	p.Conclude()
}
