//: [Previous](@previous)

import Foundation

class Counter: @unchecked Sendable {
    let queue = DispatchSerialQueue(label: ".com.app.serial")
    var counter = 0
    var value: Int {
        queue.sync {
            counter
        }
    }

    func increment() {
        queue.sync {
            counter += 1
        }
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
