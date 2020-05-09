package chapter

import (
	"sync"
	"time"
)

var (
	signal   = make(chan struct{})
	atsignal = makeNewAtomicSemaphore()
	puzzleWG sync.WaitGroup
)

// atomicSignal does not allow direct access to the semaphore.
// Interaction is applied via functions, ensured to be atomic with the waitgroup.
// Thus reading before writing is possible, and race conditions avoided.
// It is most suitable for bi-directional communication.
type atomicSignal struct {
	signal chan struct{}
	wg     sync.WaitGroup
}

func makeNewAtomicSemaphore() *atomicSignal {
	return &atomicSignal{
		// This buffer makes it possible to write without fear of deadlock.
		// Provided you read first...
		signal: make(chan struct{}, 1),
	}
}

// Read is a blocking call until the semaphore is written to. Hope someone does!
func (ats *atomicSignal) Read() {
	<-ats.signal
}

// Sample returns true if the semaphore contained a message or false if it did not.
func (ats *atomicSignal) Sample() bool {
	select {
	case <-ats.signal:
		return true
	default:
		return false
	}
}

// ReadUntil either returns true if the semaphore contains a message, or returns false after the timeout if no message was ever written. Returns immediately on write-heard.
func (ats *atomicSignal) ReadUntil(t time.Duration) bool {
	select {
	case <-ats.signal:
		return true
	case <-time.After(t):
		return false
	}
}

// Use provides atomic access to the channel by accepting a function and applying it to the internal semaphore.
// This is useful for preventing race conditions because one can detect if someone wrote before you did on a mutually exclusive operation. Like taking lunch.
func (ats *atomicSignal) Use(f func(s chan struct{})) {
	ats.wg.Wait()
	ats.wg.Add(1)
	f(ats.signal)
	ats.wg.Done()
}
