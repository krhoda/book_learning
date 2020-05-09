package chapter

import (
	"fmt"
	"log"
	"sync"

	"github.com/krhoda/little-book-of-channels/puzzle"
)

var (
	Chapter3 = []puzzle.Record{
		{
			ChapVerse: "3.1",
			QType:     "Puzzle",
			Number:    1,
			Question:  "Generalize the signal pattern in such that the program:\nThread A:\n\tstatement 1\n\tstatement 2\nThread B:\n\tstatement 1\n\tstatement 2\na1 will occur before b2 and b1 will occur before a2",
			Demo:      runSequencer,
			Conclude:  func() {},
		},
		{
			ChapVerse: "3.4",
			QType:     "Puzzle",
			Number:    2,
			Question:  "Add synchronization to the follwing example to enforce mutual exlusion:\nThread A:\ncount = count + 1\nThread B:\ncount = count + 1",
			Demo:      runMutexCount,
			Conclude:  func() {},
		},
		{
			ChapVerse: "3.5",
			QType:     "Puzzle",
			Number:    3,
			Question:  "Generalize the previous solution to allow n workers to enter the crtical section at the same time",
			Demo:      runMultiplexPuzzle,
			Conclude:  func() {},
		},
		{
			ChapVerse: "3.6",
			QType:     "Puzzle",
			Number:    4,
			Question:  "Generalize a rendezvous solution to the following code:\nrendezvous\ncritical point",
			Demo:      runGenRendez,
			Conclude:  func() {},
		},
		{
			ChapVerse: "3.7",
			QType:     "Puzzle",
			Number:    5,
			Question:  "Generalize a resuable barrier where 'turnstile' is locked again after each use.",
			Demo:      runTurnstile,
			Conclude:  func() {},
		},
		{
			ChapVerse: "3.8",
			QType:     "Puzzle",
			Number:    6,
			Question:  "Simulate a dance floor where a leader must rendezvous with a follower before proceeding.",
			Demo: func() {
				runDanceFloor()
			},
			Conclude: func() {},
		},
	}
)

func runDanceFloor() {
	leaders := []leader{
		{
			Name: "Cleo",
		},
		{
			Name: "Eudoxia",
		},
		{
			Name: "Catherine",
		},
		{
			Name: "Xenobia",
		},
	}

	followers := []follower{
		{
			Name: "Julius",
		},
		{
			Name: "Theodocius",
		},

		{
			Name: "Peter",
		},

		{
			Name: "Hannibal",
		},
	}

	meetingPoint := make(chan follower)

	puzzleWG.Add(len(followers) + len(leaders)) // Make sure the async started.
	// Extra go-routines for max asynchrony.

	go func(c chan follower) {
		for i := 0; i < len(leaders); i++ {
			go func(i int) {
				leaders[i].Lead(c)
				puzzleWG.Done()
			}(i)
		}
	}(meetingPoint)

	go func(c chan follower) {
		for i := 0; i < len(followers); i++ {
			go func(i int) {
				followers[i].Follow(c)
				puzzleWG.Done()
			}(i)
		}
	}(meetingPoint)

	puzzleWG.Wait()

}

type leader struct {
	Name string
}

func (l *leader) Lead(c chan follower) {
	f := <-c
	fmt.Printf("Leader %s has selected follower %s to dance with.\n", l.Name, f.Name)
}

type follower struct {
	Name string
}

func (f *follower) Follow(c chan follower) {
	// The next line shows why the exclusive queue is trivial in Golang.
	// We can simply pass the entire struct through and future computations can
	// combine both contexts.
	c <- *f
	fmt.Printf("Follower %s has been selected!\n", f.Name)
}

/* Turnstile is a golang equivilant the Barrier class found on page 44 figure 3.7.7 */
type Turnstile struct {
	firstGuard  chan interface{} // Block until 1st Rendevous.
	first       sync.WaitGroup
	secondGuard chan interface{} // Block after 1st Rendevous.
	second      sync.WaitGroup
}

func NewTurnstile(threads int) *Turnstile {
	t := &Turnstile{
		firstGuard:  make(chan interface{}, threads),
		first:       sync.WaitGroup{},
		secondGuard: make(chan interface{}, threads),
		second:      sync.WaitGroup{},
	}

	t.first.Add(1)
	go t.manage(threads)

	return t
}

func (turnstile *Turnstile) manage(cap int) {
	for {
		for i := 0; i < cap; i++ {
			_, ok := <-turnstile.firstGuard
			if !ok {
				return
			}
		}

		turnstile.second.Add(1)
		turnstile.first.Done()

		for i := 0; i < cap; i++ {
			_, ok := <-turnstile.secondGuard
			if !ok {
				return
			}
		}

		turnstile.first.Add(1)
		turnstile.second.Done()
	}
}

func (turnstile *Turnstile) Start() {
	turnstile.firstGuard <- nil
	turnstile.first.Wait()
}

func (turnstile *Turnstile) Done() {
	turnstile.secondGuard <- nil
	turnstile.second.Wait()
}

func contrived(threadNum, section, index int) {
	str := fmt.Sprintf("Thread Num %d in CRITICAL SECTION %d visit #%d", threadNum, section, index+1)
	puzzle.PrintExercise(str)
}

func composedContrived(threadNum, max int, turnstile *Turnstile) {
	for i := 0; i < max; i++ {
		turnstile.Start()
		contrived(threadNum, 1, i)
		turnstile.Done()
		contrived(threadNum, 2, i)
	}
}

func runTurnstile() {
	puzzle.PrintExercise("Will create 4 (n) threads, will force 10 (n) Rendevouz between 2 (n) sections of code.")
	puzzle.PrintExercise("Turnstile.Start() for the initial barrier and Turnstile.Done() works as the second sync.")

	threads := 4
	t := NewTurnstile(threads)

	puzzleWG.Add(threads)

	for i := 0; i < threads; i++ {
		go func(i int) {
			composedContrived(i, 10, t)
			puzzleWG.Done()
		}(i)
	}

	puzzleWG.Wait()
}

func runGenRendez() {
	puzzle.PrintExercise("Will create 22 threads, force a rendezvous then allow them all to print 'CRITICAL SECTION!'")
	var rendez sync.WaitGroup
	puzzleWG.Add(22)
	rendez.Add(22)

	thd := func(label int) {
		fmt.Printf("Thread no. %d is awaiting redezvous...\n", label)
		rendez.Done()
		rendez.Wait()
		fmt.Println("CRITICAL SECTION!")
		puzzleWG.Done()
	}

	for i := 0; i < 22; i++ {
		go thd(i)
	}
	puzzleWG.Wait()

	puzzle.PrintExercise("Complete!")
}

func runMultiplexPuzzle() {
	puzzle.PrintExercise("Let's try 10 workers with a multiplex of 2")
	nMultiplex(2, 10)
	puzzle.PrintExercise("Let's how about 40 workers with a multiplex of 20")
	nMultiplex(20, 40)
	puzzle.PrintQuestion("Good! Good!")
}

func nMultiplex(multiplexN, workerN int) {
	count := 0
	multiplex := make(chan struct{}, multiplexN)
	puzzleWG.Add(workerN)

	wrkr := func(name string) {
		defer func() {
			multiplex <- struct{}{}
			puzzleWG.Done()
		}()

		select {
		case <-multiplex:
			fmt.Printf("Worker %s passed mutliplex immediately\n", name)
			count += 1
			fmt.Printf("Worker %s applied inc sees count as %d\n", name, count)
		default:
			fmt.Printf("Worker %s waiting on mutliplex\n", name)
			<-multiplex
			fmt.Printf("Worker %s passed mutliplex after waiting\n", name)
			count += 1
			fmt.Printf("Worker %s applied inc sees count as %d\n", name, count)
		}
	}

	go func() {
		for i := 0; i < multiplexN; i++ {
			go func() {
				multiplex <- struct{}{}
			}()
		}
	}()

	for j := 0; j < workerN; j++ {
		go wrkr(fmt.Sprintf("Number #%d", j))
	}

	puzzleWG.Wait()
	conclusion := fmt.Sprintf(
		"Ideal count would be %d\nworst case count would be %d\nactual count %d",
		workerN,
		(workerN / multiplexN),
		count,
	)
	puzzle.PrintExercise(conclusion)
}

func runMutexCount() {
	worked := oneMutualExclusion()
	if !worked {
		log.Fatal("Halting in presence of race condition.")
	}
	puzzle.PrintQuestion("That wasn't so bad, let's test it with 100 iterations!")

	for i := 0; i < 100; i++ {
		worked := oneMutualExclusion()
		if !worked {
			log.Fatal("Halting in presence of race condition.")
		}
	}
	puzzle.PrintQuestion("Onward!")
}

func oneMutualExclusion() bool {
	buffChan := make(chan struct{}, 1)
	buffChan <- struct{}{}

	count := 0
	fmt.Printf("Count is %d\n", count)
	puzzleWG.Add(2)

	go func() {
		<-buffChan
		fmt.Println("Thread A is about to add...")
		count += 1
		fmt.Printf("Count is %d\n", count)
		buffChan <- struct{}{}
		puzzleWG.Done()
	}()

	go func() {
		<-buffChan
		fmt.Println("Thread B is about to add...")
		count += 1
		fmt.Printf("Count is %d\n", count)
		buffChan <- struct{}{}
		puzzleWG.Done()
	}()

	puzzleWG.Wait()
	if count != 2 {
		fmt.Println("RACE CONDITION DETECTED:")
		fmt.Printf("EXPECTED COUNT TO EQUAL 2, count = %d\n", count)
		return false
	}

	fmt.Printf("Count is %d as expected!\n", count)
	return true
}

func runSequencer() {
	puzzle.PrintExercise("We'll start with what was asked...")

	unleashListOfLists(sequenceListTest)

	puzzle.PrintExercise("But you said generalize! I can do n statements of n threads!")
	puzzle.PrintExercise("Lets try five threads each with a different number of statements")
	puzzle.PrintExercise("len(a) == 2\nlen(b) == 1\nlen(c) == 5\nlen(d) == 3\nlen(e) == 4")

	unleashListOfLists(betterSequenceListTest)

	puzzle.PrintExercise("With a little recursion, we can co-ordinate them too")
	sequenceListOfLists(betterSequenceListTest)
}

var sequenceListTest = [][]func(){
	{
		func() {
			fmt.Println("a1")
		},
		func() {
			fmt.Println("a2")
		},
	},
	{
		func() {
			fmt.Println("b1")
		},
		func() {
			fmt.Println("b2")
		},
	},
}

var betterSequenceListTest = [][]func(){
	{
		func() {
			fmt.Println("a1")
		},
		func() {
			fmt.Println("a2")
		},
	},
	{
		func() {
			fmt.Println("b1")
		},
	},
	{
		func() {
			fmt.Println("c1")
		},
		func() {
			fmt.Println("c2")
		},
		func() {
			fmt.Println("c3")
		},
		func() {
			fmt.Println("c4")
		},
		func() {
			fmt.Println("c5")
		},
	},
	{
		func() {
			fmt.Println("d1")
		},
		func() {
			fmt.Println("d2")
		},
		func() {
			fmt.Println("d3")
		},
	},
	{
		func() {
			fmt.Println("e1")
		},
		func() {
			fmt.Println("e2")
		},
		func() {
			fmt.Println("e3")
		},
		func() {
			fmt.Println("e4")
		},
	},
}

// The world's goofiest synchronizer.
func sequenceListOfLists(sequenceList [][]func()) {
	// create generic communication list:
	readyList, concludeList := []chan struct{}{}, []chan struct{}{}

	// create general end command.
	done := make(chan struct{})

	// start with zero, listen for max during co-routine creation.
	maxActions := 0

	// know how many for later iteration.
	maxSection := len(sequenceList)

	// used to prevent the main thread from exiting early.
	var sequenceWG sync.WaitGroup

	for _, sequence := range sequenceList {
		// init, then distribute messaging.
		ready, conclude := make(chan struct{}), make(chan struct{})

		readyList = append(readyList, ready)
		concludeList = append(concludeList, conclude)

		maybeMax := len(sequence)
		if maxActions < maybeMax {
			maxActions = maybeMax
		}

		// Pass the var, because we can't close over a loop var here.
		go func(s []func()) {
			// keep the main thread alive.
			sequenceWG.Add(1)
			sequenceListOfActions(s, ready, conclude, done)
			// free the main thread.
			sequenceWG.Done()
		}(sequence)
	}

	// For each action...
	for action := 0; action < maxActions; action++ {
		// ...Iterate through all sections.
		for section := 0; section < maxSection; section++ {
			// permit one action.
			readyList[section] <- struct{}{}
			// confirm one action.
			<-concludeList[section]
		}
	}

	// notifies concluded threads.
	close(done)

	// awaits all returns.
	sequenceWG.Wait()
}

func unleashListOfLists(sequenceList [][]func()) {
	// Fan-In of co-routines, readevuex with conclude iter.
	concludeAction, concludeIteration := make(chan struct{}), make(chan struct{})

	// start with zero, listen for max during co-routine creation.
	maxActions := 0

	// know how many for later iteration.
	maxSection := len(sequenceList)
	for _, sequence := range sequenceList {
		maybeMax := len(sequence)
		if maxActions < maybeMax {
			maxActions = maybeMax
		}
	}

	// For each action...
	for action := 0; action < maxActions; action++ {
		// Set up aggregator of section actions.
		go handleUnleashAction(maxSection, concludeAction, concludeIteration)

		for section := 0; section < maxSection; section++ {
			f := func() {}
			if len(sequenceList[section]) > action {
				f = sequenceList[section][action]
			}

			go unleashAction(f, concludeAction)
		}
		<-concludeIteration
	}
}

func unleashAction(f func(), conclude chan struct{}) {
	f()
	conclude <- struct{}{}
}

func handleUnleashAction(sectionNum int, concludeAction, concludeIteration chan struct{}) {
	counter := 0
	for counter < sectionNum {
		<-concludeAction
		counter++
	}
	concludeIteration <- struct{}{}
}

func sequenceListOfActions(sequence []func(), ready, conclude, done chan struct{}) {
	select {
	case <-ready:
		// if actions remain in the sequence execute it.
		if len(sequence) > 0 {
			var f func()
			// redefine sequence to it's tail:
			f, sequence = sequence[0], sequence[1:]
			f()
		}

		// allow the main thread to proceed
		conclude <- struct{}{}

		// recur. if empty, will simply inform the main thread to continue until...
		sequenceListOfActions(sequence, ready, conclude, done)

	case <-done:
		// ...all actions must be done.
	}
}
