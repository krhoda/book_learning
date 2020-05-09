package cmd

import (
	"log"
	"os"
	"strconv"

	"github.com/krhoda/little-book-of-channels/puzzle"
	"github.com/spf13/cobra"
)

var (
	rootCmd = &cobra.Command{
		Use:   "puzz",
		Short: "Puzzle Runner -- Run as much or as little as you like.",
		Long:  "List puzzles, list questions, run puzzles, be amazed!",
		Run: func(cmd *cobra.Command, args []string) {
			PrintIntro()
			os.Exit(0)
		},
	}

	runCmds = &cobra.Command{
		Use:   "run",
		Short: "Runs a different set of puzzles, depending on args passed",
		Long:  "Runs a different set of puzzles, depending on args passed\nNo args: All,\n1 int: All from given chapter,\n2 ints: given puzzle from given chapter",
		Run: func(cmd *cobra.Command, args []string) {
			check := len(args)
			if check == 0 {
				runAllPuzzles()
				os.Exit(0)
			}

			if check == 1 {
				target, err := strconv.Atoi(args[0])
				handleIntError(err)

				err = runChapterPuzzles(target)
				if err != nil {
					log.Fatal(err)
				}

				os.Exit(0)
			}

			if check == 2 {
				chapStr := args[0]
				puzzStr := args[1]

				puzz, err := strconv.Atoi(puzzStr)
				handleIntError(err)
				chap, err := strconv.Atoi(chapStr)
				handleIntError(err)

				err = runSpecificPuzzle(chap, puzz)
				if err != nil {
					log.Fatal(err.Error())
				}

				os.Exit(0)
			}

			log.Fatal("Must pass either 0, 1 or 2 arguments to run and list.")
		},
	}

	listCmds = &cobra.Command{
		Use:   "list",
		Short: "Lists a different set of puzzle questions, depending on args passed",
		Long:  "Lists a different set of puzzle questions, depending on args passed\nNo args: All,\n1 int: All from given chapter,\n2 ints: given puzzle from given chapter",
		Run: func(cmd *cobra.Command, args []string) {
			check := len(args)
			if check == 0 {
				listAllPuzzles()
				os.Exit(0)
			}

			if check == 1 {
				target, err := strconv.Atoi(args[0])
				handleIntError(err)

				err = listChapterPuzzles(target)
				if err != nil {
					log.Fatal(err)
				}

				os.Exit(0)
			}

			if check == 2 {
				chapStr := args[0]
				puzzStr := args[1]

				puzz, err := strconv.Atoi(puzzStr)
				handleIntError(err)

				var chap int
				chap, err = strconv.Atoi(chapStr)
				handleIntError(err)

				err = listSpecificPuzzle(chap, puzz)
				if err != nil {
					log.Fatal(err.Error())
				}
				os.Exit(0)
			}

			log.Fatal("Must pass either 0, 1 or 2 arguments to run and list.")
		},
	}
)

// handleIntError really sounds like it's more than it is.
func handleIntError(err error) {
	if err != nil {
		log.Fatal("Must pass valid integers to run and list.")
	}
}

func Execute() error {
	rootCmd.AddCommand(runCmds)
	rootCmd.AddCommand(listCmds)
	return rootCmd.Execute()
}

func PrintIntro() {
	puzzle.PrintHeader("...")
	puzzle.PrintHeader("Welcome to the Puzzle Runner for my Golang answers to Allen Downey's little book of semaphores.")
	puzzle.PrintHeader("There are the following commands:")
	puzzle.PrintHeader("run -- Runs all Questions and Answers, Plenty of Output!")
	puzzle.PrintHeader("run $1  -- Runs all Questions and Answers from given chapter")
	puzzle.PrintHeader("run $1 $2 -- Run Question and Answer no. $2 from chapter $1")
	puzzle.PrintHeader("list all  -- Lists all Questions from every chapter")
	puzzle.PrintHeader("list $1  -- Lists all Questions from given chapter")
	puzzle.PrintHeader("list $1 $2 -- List Question no. $2 from chapter $1")
}
