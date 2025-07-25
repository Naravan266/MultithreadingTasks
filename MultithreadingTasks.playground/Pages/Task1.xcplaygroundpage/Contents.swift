//: [Previous](@previous)

import Foundation

// I now got what is the issue here and how to use NSLock(). Due to the fact that both threads have uncontrolled access to the increment function, they use it both at the same time without any control. The simplest way to solve the issue is just to control the access to the increment function by setting lock when the function starts and removing it once it finishes doing its job. So basically in previous case I overthought the issue and made the solution unnecessary complex by adding counter.

class Counter: @unchecked Sendable {
    var value = 0
    let nsLock = NSLock()

    func increment() {
        nsLock.lock()
        defer { nsLock.unlock()}
        value += 1
    }
}

func runCounterTask() {
    let counter = Counter()

    let thread1 = Thread {
        for _ in 1...1000 {
            counter.increment()
        }
    }

    let thread2 = Thread {
        for _ in 1...1000 {
            counter.increment()
        }
    }

    thread1.start()
    thread2.start()

    while thread1.isExecuting || thread2.isExecuting {
        usleep(100)
    }

    print("Final counter value: \(counter.value) (Expected: 2000, but will likely be incorrect)")
}

runCounterTask()
