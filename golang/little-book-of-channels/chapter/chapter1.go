package chapter

import (
	"fmt"
	"math/rand"
	"strconv"
	"time"

	"github.com/krhoda/little-book-of-channels/puzzle"
)

var (
	Chapter1 = []puzzle.Record{
		{
			ChapVerse: "1.5.1",
			QType:     "Puzzle",
			Number:    1,
			Question:  "If thread A equals:\nx = 5\nprint x\n\nAnd thread B equals:\nx = 7\n\nWhat path leads to the printing of 5 and the final value of 5?",
			Demo:      alwaysPrintsFive,
			Conclude:  func() {},
		},
		{
			ChapVerse: "1.5.1",
			QType:     "Puzzle",
			Number:    2,
			Question:  "What path leads to the printing of 7 and final value of 7?",
			Demo:      alwaysPrintsSeven,
			Conclude:  func() {},
		},
		{
			ChapVerse: "1.5.1",
			QType:     "Puzzle",
			Number:    3,
			Question:  "Can you print 7 and result in a final value of 5?",
			Demo: func() {
				puzzle.PrintExercise("No. Because assigment to 5 and printing occur in that order in the same thread, they cannot be re-arranged.")
			},
			Conclude: func() {},
		},
		{
			ChapVerse: "1.5.2",
			QType:     "Puzzle",
			Number:    1,
			Question:  "Suppose that 100 threads run the following program concurrenly:\n\nfor i in range(100):\n\ttemp = count\n\tcount = temp + 1\n\nWhat is the largest possible value of count after all threads have completed?",
			Demo:      printsMaxTempCount,
			Conclude:  func() {},
		},

		{
			ChapVerse: "1.5.2",
			QType:     "Puzzle",
			Number:    2,
			Question:  "What is the smallest possible value of count after all threads have completed?",
			Demo:      printsMinTempCount,
			Conclude:  func() {},
		},

		{
			ChapVerse: "1.5.3",
			QType:     "Puzzle",
			Number:    2,
			Question:  "Under a scenerio where one of two agents must always be 'watching', but either can 'take lunch', construct a message passing scheme which confirms that only one takes lunch at a time.",
			Demo:      twoAgentsTakingLunch,
			Conclude:  func() {},
		},
	}
)

func alwaysPrintsFive() {
	var x *int
	y := 5
	z := 7

	puzzleWG.Add(1)
	puzzleWG.Add(1)

	go func() {
		<-signal
		x = &y
		puzzle.PrintExercise(fmt.Sprintf("Thread A sees x as: %s", strconv.Itoa(*x)))
		puzzleWG.Done()
	}()

	go func() {
		x = &z
		signal <- struct{}{}
		puzzleWG.Done()
	}()

	puzzleWG.Wait()

	puzzle.PrintExercise(fmt.Sprintf("The final result sees x as: %s", strconv.Itoa(*x)))
}

func alwaysPrintsSeven() {
	var x *int
	y := 5
	z := 7

	puzzleWG.Add(1)
	puzzleWG.Add(1)

	go func() {
		x = &y
		signal <- struct{}{}
		<-signal

		puzzle.PrintExercise(fmt.Sprintf("Thread A sees x as: %s", strconv.Itoa(*x)))
		puzzleWG.Done()
	}()

	go func() {
		<-signal
		x = &z
		signal <- struct{}{}
		puzzleWG.Done()
	}()

	puzzleWG.Wait()
	puzzle.PrintExercise(fmt.Sprintf("The final result sees x as: %s", strconv.Itoa(*x)))
}

// By requiring a read of the signal before a write of the pointer, we are able ensure everyone correctly increments the counter.
// The only oddity is writing to the signal initially to provide the first co-routine "authority" to interact with the pointer.
func printsMaxTempCount() {
	var count *int
	tempZero := 0

	count = &tempZero

	// used to wait for the completion of the puzzle start.
	puzzleDone := make(chan struct{}, 101)

	// prime the signal for the actual exercise:
	go func() {
		signal <- struct{}{}
	}()

	for i, x := 0, 100; i < x; i++ {
		go func() {
			for j, y := 0, 100; j < y; j++ {
				<-signal

				temp := *count
				temp++
				count = &temp

				signal <- struct{}{}
			}

			puzzleDone <- struct{}{}
		}()
	}

	doneCount := 0
	for doneCount < 99 {
		<-puzzleDone
		doneCount++
		puzzle.PrintExercise(fmt.Sprintf("Heard Thread %d Complete.", doneCount))
	}

	puzzle.PrintExercise(fmt.Sprintf("Count is now %d, the maximimum amount.", *count))
}

// 1.5.2 100 Co-Routines updating a shared counter with the MOST missed updates
// To negotiate this, every step must be blocking. Using this listener, a single thread can co-ordinate between n workers and make them behave as if they were 1 worker.
type minCountListener struct {
	PointerTaken chan struct{}
	SetReady     chan struct{}
	PointerSet   chan struct{}
	TakenReady   chan struct{}
}

func newMinCountListener() *minCountListener {
	return &minCountListener{
		PointerSet:   make(chan struct{}),
		PointerTaken: make(chan struct{}),
		SetReady:     make(chan struct{}),
		TakenReady:   make(chan struct{}),
	}
}

func (mcl *minCountListener) Run(workerCount, interations int) {
	for i := 0; i < interations; i++ {
		pointerTakenHeard := 0
		pointerSetHeard := 0
		workersReady := 0

		puzzle.PrintExercise(fmt.Sprintf("About to start iteration %d", i))

		// Alert workers to take the pointer.
		for workersReady < (workerCount - 1) {
			mcl.TakenReady <- struct{}{}
			workersReady++
		}
		puzzle.PrintExercise(fmt.Sprintf("All workers ready to take pointer in iteration %d", i))

		// Block until worker has taken the pointer.
		for pointerTakenHeard < (workerCount - 1) {
			<-mcl.PointerTaken
			pointerTakenHeard++
		}
		puzzle.PrintExercise(fmt.Sprintf("All pointers taken in iteration %d", i))

		workersReady = 0

		//  Alert workers to set pointer.
		for workersReady < (workerCount - 1) {
			mcl.SetReady <- struct{}{}
			workersReady++
		}
		puzzle.PrintExercise(fmt.Sprintf("All workers ready to set pointer in iteration %d", i))

		// Block until every one confirmed they set pointer.
		for pointerSetHeard < (workerCount - 1) {
			<-mcl.PointerSet
			pointerSetHeard++
		}
		puzzle.PrintExercise(fmt.Sprintf("All pointers set in iteration %d", i))

		// Repeat
	}

	puzzle.PrintExercise("All iterations concluded")
}

func printsMinTempCount() {
	var count *int
	tempZero := 0

	count = &tempZero
	iterations, workers := 100, 100

	mcl := newMinCountListener()

	go func() {
		for i := 0; i < workers; i++ {
			go func() {
				for j := 0; j < iterations; j++ {
					// Wait for the co-ordinater's go-ahead.
					<-mcl.TakenReady

					temp := *count
					temp++

					// Tell the co-ordinater "I'm Ready".
					mcl.PointerTaken <- struct{}{}

					// Wait for the co-ordinater's go-ahead.
					<-mcl.SetReady

					count = &temp

					// Tell the co-ordinater "I'm Done".
					mcl.PointerSet <- struct{}{}

				}
			}()
		}
	}()

	mcl.Run(workers, iterations)

	puzzle.PrintExercise(fmt.Sprintf("Count is now %d, the minimum amount.", *count))
	puzzle.PrintExercise("Thus n workers will always equal 1 worker in this scheme.")
}

// 1.5.3 Lunch Taking Message Passing System
const breakTakingAgentLunchTime = 5

// Combined with the global atsignal, these two channels will be all that is required to readably perform this.
// Using the atsignal (atomicSignal) for requests prevents both actors from requesting lunch at the same time -- then deadlocking.
type breakTakingAgentLunchBox struct {
	Approve  chan struct{}
	Conclude chan struct{}
}

func makeBreakTakingAgentLunchBox() *breakTakingAgentLunchBox {
	return &breakTakingAgentLunchBox{
		Approve:  make(chan struct{}),
		Conclude: make(chan struct{}),
	}
}

type breakTakingAgent struct {
	Name     string
	Lunchbox *breakTakingAgentLunchBox
}

func makeBreakTakingAgent(n string) *breakTakingAgent {
	return &breakTakingAgent{
		Name:     n,
		Lunchbox: makeBreakTakingAgentLunchBox(),
	}
}

func (a *breakTakingAgent) Work(watchtime time.Duration, other *breakTakingAgent) {
	puzzle.PrintExercise(fmt.Sprintf("Worker %s going to watch %v seconds", a.Name, watchtime))

	// Allows us to know if lunch time has occured in any future state of execution.
	lunchTimer := make(chan struct{})
	go func() {
		<-time.After(watchtime)

		puzzle.PrintExercise(fmt.Sprintf("The ideal lunchtime for Worker %s has passed!", a.Name))
		lunchTimer <- struct{}{}

		close(lunchTimer)
	}()

	// Block reading for requests until lunchtime.
	req := atsignal.ReadUntil(watchtime)

	// Broke early for a request, better approve!
	if req {
		// One agent will always end up calling this function.
		a.handleAgentRequest(other, lunchTimer)
		return
	}

	puzzle.PrintExercise(fmt.Sprintf("Worker %s is sending request to Worker %s for lunch.", a.Name, other.Name))

	// Compose a function for atomicSignal to use.
	f := a.makeSendRequest(other, lunchTimer)

	// In case of race condition, both agents will reach this point.
	// If that happens it will be resolved in a.sendAgentLunchReq
	atsignal.Use(f)

	// One agent will always reach this point.
	// Wait for appoval.
	<-a.Lunchbox.Approve

	puzzle.PrintExercise(fmt.Sprintf("Worker %s is eating lunch", a.Name))
	time.Sleep(breakTakingAgentLunchTime * time.Second)
	puzzle.PrintExercise(fmt.Sprintf("Worker %s is done with lunch", a.Name))

	// give the go ahead for other lunches.
	a.Lunchbox.Conclude <- struct{}{}

	puzzleWG.Done()
	puzzleWG.Wait()
}

func (a *breakTakingAgent) sendAgentLunchReq(other *breakTakingAgent, lunchTimer, reqSignal chan struct{}) {
	select {
	case <-reqSignal:
		// This branch catches race conditions when requesting lunch.
		a.handleAgentRequest(other, lunchTimer)
	default:
		// Expected execution:
		reqSignal <- struct{}{}
	}
}

func (a *breakTakingAgent) makeSendRequest(other *breakTakingAgent, lunchTimer chan struct{}) func(chan struct{}) {

	// Compose the breakTakingAgent method into a function ats can use:
	return func(s chan struct{}) {
		a.sendAgentLunchReq(other, lunchTimer, s)
	}
}

func (a *breakTakingAgent) handleAgentRequest(other *breakTakingAgent, lunchTimer chan struct{}) {
	puzzle.PrintExercise(fmt.Sprintf("Worker %s heard request from Worker %s for lunch.\nApproving!", a.Name, other.Name))

	// Submit approval
	other.Lunchbox.Approve <- struct{}{}

	puzzle.PrintExercise(fmt.Sprintf("Worker %s is now waiting for worker %s to conclude lunch.", a.Name, other.Name))

	// Hear the far end concluded.
	<-other.Lunchbox.Conclude

	puzzle.PrintExercise(fmt.Sprintf("Worker %s has heard worker %s has concluded lunch. Lovely!\nNow waiting for own lunch", a.Name, other.Name))

	// Wait for / Discover it is already lunchtime.
	<-lunchTimer

	puzzle.PrintExercise(fmt.Sprintf("Worker %s is taking lunch.", a.Name))
	time.Sleep(breakTakingAgentLunchTime)
	puzzle.PrintExercise(fmt.Sprintf("Worker %s is done with lunch.", a.Name))

	puzzleWG.Done()
	puzzleWG.Wait()
}

func twoAgentsTakingLunch() {
	ada, joe := makeBreakTakingAgent("Ada"), makeBreakTakingAgent("Joe")

	puzzle.PrintExercise("Starting workers 'Ada' and 'Joe'...")
	puzzle.PrintExercise("...Using random times between 0 and 10 seconds")

	adaWT, joeWT := (time.Duration(rand.Intn(10)) * time.Second), (time.Duration(rand.Intn(10)) * time.Second)

	puzzleWG.Add(2)

	go ada.Work(adaWT, joe)
	go joe.Work(joeWT, ada)

	puzzleWG.Wait()

	puzzle.PrintExercise("Starting workers 'Ada' and 'Joe'...")
	puzzle.PrintExercise("...Forcing a race condition")

	puzzleWG.Add(2)

	go ada.Work(time.Duration(5*time.Second), joe)
	go joe.Work(time.Duration(5*time.Second), ada)

	puzzleWG.Wait()

	puzzle.PrintExercise("The minimum messages needed with channels is 3:\n1) Request,\n2) Approve,\n3) Conclude")
	puzzle.PrintExercise("Without Request, they could take lunch at the same time.")
	puzzle.PrintExercise("Without Approve, they could take lunch at the same time")
	puzzle.PrintExercise("Without Conclude, one may take lunch before the other is back.")
}
