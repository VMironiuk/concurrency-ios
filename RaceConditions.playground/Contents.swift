import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

struct RaceConditionDemo {
    private class Counter {
        private(set) var count: Int = 0
        func increment() {
            count += 1
        }
    }

    static func run() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        let counter = Counter()
        
        for _ in 1...1000 {
            queue.async(group: group) {
                Thread.sleep(until: Date().addingTimeInterval(0.05))
                counter.increment()
            }
        }
        
        group.notify(queue: .main) {
            print(counter.count)
            PlaygroundPage.current.finishExecution()
        }
    }
}

//RaceConditionDemo.run()

struct PreventRaceConditionWithSerialQueueSync {
    private class Counter {
        private let threadSafeCountQueue = DispatchQueue(label: "vladimironiuk.com")
        private(set) var count: Int = 0
        func increment() {
            threadSafeCountQueue.sync {
                count += 1
            }
        }
    }
    
    static func run() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        let counter = Counter()
        
        for _ in 1...1000 {
            queue.async(group: group) {
                Thread.sleep(until: Date().addingTimeInterval(0.05))
                counter.increment()
            }
        }
        
        group.notify(queue: .main) {
            print(counter.count)
            PlaygroundPage.current.finishExecution()
        }
    }
}

//PreventRaceConditionWithSerialQueueSync.run()

struct PreventRaceConditionWithBarrier {
    private class Counter {
        private let threadSafeIncrementQueue = DispatchQueue(label: "vladimironiuk.com")
        private let threadSafeCountQueue = DispatchQueue(label: "vladimironiuk.com.Barrier", attributes: .concurrent)
        private var _count: Int = 0
        private(set) var count: Int {
            get {
                threadSafeCountQueue.sync {
                    _count
                }
            }
            set {
                threadSafeCountQueue.async(flags: .barrier) { [unowned self] in
                    self._count = newValue
                }
            }
        }
        func increment() {
            threadSafeIncrementQueue.sync {
                count += 1
            }
        }
    }
    
    static func run() {
        let queue = DispatchQueue.global(qos: .userInitiated)
        let group = DispatchGroup()
        let counter = Counter()
        
        queue.async(group: group) {
            for i in 1...1000 {
                print("READ... (#\(i), count=\(counter.count))")
                Thread.sleep(until: Date().addingTimeInterval(0.025))
            }
        }
        
        queue.async(group: group) {
            for i in 1...1000 {
                print("WRITE... (#\(i))")
                Thread.sleep(until: Date().addingTimeInterval(0.025))
                counter.increment()
            }
        }
        
        group.notify(queue: .main) {
            print("ALL JOBS DONE (count=\(counter.count))")
            PlaygroundPage.current.finishExecution()
        }
    }
}

PreventRaceConditionWithBarrier.run()
