# Book Learning 
## A collection of project/sample code in many languages from many books for many purposes.

### Alphabetic breakdown by language family:

### BEAM Languages
#### Elixir
Coming soon, [Elixir in Action](https://www.manning.com/books/elixir-in-action-second-edition)
#### Erlang
##### hello_joe
Joe Armstrong's [Programming In Erlang](https://pragprog.com/book/jaerlang2/programming-erlang)
Amazingly productive exercises, beginning with a file server and layering complexity from there.
Incomplete, chapters vary between notes and exercises.

### Golang
##### Allen Downey's Little Book of Semaphores using Golang Select, Channels, and WaitGroups

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
Incomplete, but exercises are demo'd interactively!

### Lisp 
#### Clojure
Coming soon, [Clojure for the Brave and True](https://www.braveclojure.com/clojure-for-the-brave-and-true/)

#### Racket
##### Beautiful Racket
A legitimate (and wildly successful) effort to [teach Language Developement](https://beautifulracket.com/) in Racket (the purported purpose of the language). Each subdirectory is a language. Using `racket` with the `beautiful-racket` packages installed to run the `<directory_name>-test.rkt` will run the more basic languages (`stacker`, `funstacker`, `stackerizer`).
More detailed instructions for all languages found in the repository. (TODO: MAKE REAL OR PUT HERE)
Incomplete, but each demo is self contained.

##### How To Design Programs
A modern and excellent approach to teaching [programming from the ground up](https://htdp.org/). Naturally and silently promotes functional programming and test driven development by virtue of utilizing testing for project planning and functional style to make testing easy. Very, very clever and fun. Recommended for all skill levels!
Incomplete, hard to run/read without DrRacket, but I'll build out that virtual pet game one day.

##### Structure and Interpretation of Computer Programs
The classic mind-expanding [MIT Text](https://web.mit.edu/alexmv/6.037/sicp.pdf). I know, I know, it's supposed to be written in `scheme`, but `racket` provides a wonderful language module specifically to complete this book -- and `racket` was already installed on my machine. Woefully incomplete, but I've watched the [MIT companion lectures](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/) and highly recommend those as well!

### Rust

#### The Rust Book
The one, the only, [the Rust book](https://doc.rust-lang.org/book/). Starting with values and ownership, growing through type-level programming, and detouring through idiomaic style and ecosystem tooling, establishes everything one needs to know to confidently start building with Rust. It's a long journey, but it's clear enough (if going in knowing `haskell`, that is).
Complete. Every chapter contains notes and working examples.

#### The Rustnomicon
Coming soon, [The Rustonomicon](https://doc.rust-lang.org/nomicon/). Less for the `unsafe` powers, but more for a deeper understanding of the innerworking of the language, and the basis for the `concurrent`/`paralellism` models of the language.

#### WASM
A free-wheeling and somewhat odd-ball project-based exploration of [WebAssembly in Rust](https://pragprog.com/book/khrust/programming-webassembly-with-rust). Divided into 3 parts, code is arranged similarly, futher divided into projects. As they are presented in the text, some are not fully functional. 
Others deviate signifcantly from what was provided in the text, because I got too opinionated about web development module packaging (and I'd do it again!). Progress stalled when I went on a journey to discover if you could run WASM in a WebWorker, thus never blocking the UI thread (you can, but it's not a well-worn path).

Recommended if you have a strong interest in WebAssembly, this is still the best project/example-based introduction to WebAssembly out there. Not reccomended if you want all of the tooling to work nicely out of the box. The ecosystem is rough around the edges, and figuring out a work-flow that suites your tastes while still delivering the output that the author does is part of the fun/challenge of this text. To that end, I strong suggest taking a look at [wasm-pack](https://github.com/rustwasm/wasm-pack) before getting too deep into part 2 -- it's very nice.
