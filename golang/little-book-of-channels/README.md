# The Little Book of Channels
## Allen Downey's Little Book of Semaphores using Golang Select, Channels, and WaitGroups

[The wonderful free book](https://greenteapress.com/wp/semaphores/) is the subject here where we endeavor to apply the flexible, consistant, and powerful concurrency tools of Golang to the delightful puzzles described. It is simple to run (and hopefully read!) the solutions to these puzzles.

Presuming you have [Golang installed](https://golang.org/doc/install) it's as simple as cloning the repository, opening the directory, and running:

``` shell
$ go run main.go # See all commands.

$ go run main.go run     # Run all puzzles (A lot of output!)
$ go run main.go run 1   # Run all puzzles from the given chapter
$ go run main.go run 3 1 # Run from Specific chapter, specific puzzle

$ go run main.go list     # List all puzzle questions.
$ go run main.go list 1   # List all puzzle questions from the given chapter.
$ go run main.go list 3 1 # List from the chapter of the first arg and the puzzle of the second.
```

You could also `$ go install` but the binary executable will be quite a mouthful.
