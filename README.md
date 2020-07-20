# Book Learning 
## A collection of project/sample code in many languages from many books for many purposes.

#### Not listed, but still loved:
#### General 
[Game Programming Patterns](https://gameprogrammingpatterns.com/) a very readable pattern book that critically evaulates, selects, and applies patterns to specific, real-world problems. The examples are focused on games (quite enjoyably) but the concepts are widely applicable.

#### Haskell
[Learn You a Haskell for the Greater Good](http://learnyouahaskell.com/) culminated in my goofier WIP haskell projects like [cria](https://github.com/krhoda/cria) and [capitol-quiz](https://github.com/krhoda/capitol-quiz)

[Parallel and Concurrent Programming in Haskell](https://simonmar.github.io/bib/papers/par-tutorial-cefp-2012.pdf) strongly influenced the my experiments in [quartz](https://github.com/krhoda/quartz)

### Alphabetic breakdown by language family:

### BEAM Languages
#### Elixir
Coming soon, [Elixir in Action](https://www.manning.com/books/elixir-in-action-second-edition)

#### Erlang
##### hello_joe
Joe Armstrong's [Programming In Erlang](https://pragprog.com/book/jaerlang2/programming-erlang)

Amazingly productive exercises, beginning with a file server and layering complexity from there.

All contents are `.erl` files and can be interacted with via the instructions found [here](http://erlang.org/documentation/doc-5.3/doc/getting_started/getting_started.html).

Incomplete, chapters vary between notes and exercises.

### Golang
##### Allen Downey's Little Book of Semaphores using Golang Select, Channels, and WaitGroups

[This wonderful free book](https://greenteapress.com/wp/semaphores/) is on concurrent puzzles involving thread synchronization.  

Instead of a direct translation of the source listed in the book (utilizing `python` and it's threaded parallelism structures), this module utilizes the many lovely [CSP](http://usingcsp.com/cspbook.pdf) based structures available in `golang` -- most particularly, the `channel`, `goroutine`, `select`, and `waitgroup`.

It is simple to run (and hopefully read!) the source, definitions, and solutions to these puzzles.

Presuming you have [Golang installed](https://golang.org/doc/install) it's as simple as cloning the repository, opening the directory contianing the module (`book_learning/golang/little-book-of-channels`), and running:

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
A legitimate (and wildly successful) effort to [teach language developement](https://beautifulracket.com/) in Racket (the purported purpose of the language). Teaches profound lessons on lisp via the construction of 8 languages in varying degrees of sophistication.

Running the languages require Racket and Beautiful Racket's package to be installed as described [here](https://beautifulracket.com/setup.html).

`language_sandbox` contains the work done along side the book. It also contains `funstacker`, `stacker`, and `stackerizer`. Those languages can be tested via `<lang_name>-test.rkt`.

`language_dist` contains more complex languages which can be installed via

```shell
cd beautiful_racket/laugauge_dist/<language_name>
raco pkg install
```

Then feel free to run/modify the `example.rkt` files in the coresponding `beautiful_racke/examples` language directory.

##### How To Design Programs
A modern and excellent approach to teaching [programming from the ground up](https://htdp.org/). 

Naturally and silently promotes functional programming and test driven development by virtue of utilizing testing for project planning and functional style to make testing easy. Very, very clever and fun. Recommended for all skill levels!

Incomplete, hard to run/read without DrRacket, but I'll build out that virtual pet game one day.

##### Structure and Interpretation of Computer Programs
The classic mind-expanding [MIT Text](https://web.mit.edu/alexmv/6.037/sicp.pdf). 

I know, I know, it's supposed to be written in `scheme`, but `racket` provides a wonderful language module specifically to complete this book -- and `racket` was already installed on my machine. Woefully incomplete, but I've watched the [MIT companion lectures](https://ocw.mit.edu/courses/electrical-engineering-and-computer-science/6-001-structure-and-interpretation-of-computer-programs-spring-2005/video-lectures/) and highly recommend those as well!

#### Common Lisp
##### Let over Lambda
After discovering that this beloved technique had a name, and that name was shared with [a text](https://letoverlambda.com/) that acted deep dive on macros, I knew what I had to do.

Currently unstarted.

### Rust
To run any Rust project, install Rust as described [here](https://www.rust-lang.org/tools/install). 

With rare exception, `cargo run` at the root of a chapter/project will run the program.

#### The Rust Book
The one, the only, [the Rust book](https://doc.rust-lang.org/book/). 

Starting with values and ownership, growing through type-level programming, and detouring through idiomaic style and ecosystem tooling, it establishes everything one needs to know to confidently start building with Rust. 

A long journey, but clear enough (if going in knowing `haskell`, that is).

Complete. Every chapter contains notes and working examples.

#### The Complete Rust Programming Reference Guide
From what I've found, [this](https://www.packtpub.com/application-development/complete-rust-programming-reference-guide) best comprehensive, general purpose intermediate Rust Guide to follow the book which comes with the language.

Currently working through, but expecting to find:
* Deeper examination of traits and closures.
* Additional information and examples of macros.
* Performance concerned algorithmic implementations and techniques.

#### The Rustnomicon
Coming soon, [The Rustonomicon](https://doc.rust-lang.org/nomicon/). Less for the `unsafe` powers, but more for a deeper understanding of the innerworking of the language, and the basis for the `concurrent`/`paralellism` models of the language.

#### WASM
A free-wheeling and somewhat odd-ball project-based exploration of [WebAssembly in Rust](https://pragprog.com/book/khrust/programming-webassembly-with-rust). Divided into 3 parts, code is arranged similarly, futher divided into projects. As they are presented in the text, some are not fully functional. 

Others deviate signifcantly from what was provided in the text, because I got too opinionated about web development module packaging (and I'd do it again!). Progress stalled when I went on a journey to discover if you could run WASM in a WebWorker, thus never blocking the UI thread (you can, but it's not a well-worn path).

Recommended if you have a strong interest in WebAssembly, this is still the best project/example-based introduction to WebAssembly out there. Not reccomended if you want all of the tooling to work nicely out of the box. The ecosystem is rough around the edges, and figuring out a work-flow that suites your tastes while still delivering the same output that the author does is part of the fun/challenge of this text. 

To that end, I strong suggest taking a look at [wasm-pack](https://github.com/rustwasm/wasm-pack) before getting too deep into part 2 -- it's very nice.

These examples are not easy to run.

### Haskell

#### Thinking Functionally With Haskell
[The spiritual successor](https://www.cambridge.org/core/books/thinking-functionally-with-haskell/79F91D976F0C7229082325B41824EBBC#fndtn-information) to the [classic](https://www.goodreads.com/book/show/3791460-introduction-to-functional-programming) text on functional programming. 

Really, I just wanted an excuse to solve exercises in Haskell. Will update with details of the subject matter as I discover it.

### Prolog

#### The Art of Prolog (2nd Edition)
I don't know what Prolog is, but it comes with the recomendations of some of the greatest minds in programming. [Here](https://mitpress.mit.edu/books/art-prolog-second-edition) is a free book that is also loved and beloved.