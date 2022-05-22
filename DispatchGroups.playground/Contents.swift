import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

// MARK: - DispatchGroup.notify

func groupNotifyDemo1() {
    print(#function)
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInitiated)

    queue.async(group: group) {
        print("Job 1 start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job 1 finish")
    }

    queue.async(group: group) {
        print("Job 2 start")
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Job 2 finish")
    }

    group.notify(queue: .main) {
        print("All jobs done")
    }
    
    print("End of the \(#function)")
}

func groupNotifyDemo2() {
    print(#function)
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInitiated)

    queue.async(group: group) {
        print("Job 1 start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job 1 finish")
    }

    group.notify(queue: .main) {
        print("All jobs done")
    }
    
    queue.async(group: group) {
        print("Job 2 start")
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Job 2 finish")
    }
    
    print("End of the \(#function)")
}

func groupNotifyDemo3() {
    print(#function)
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInitiated)

    group.notify(queue: .main) {
        print("All jobs done")
    }

    queue.async(group: group) {
        print("Job 1 start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job 1 finish")
    }
    
    queue.async(group: group) {
        print("Job 2 start")
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Job 2 finish")
    }
    
    print("End of the \(#function)")
}

func groupNotifyDemo4() {
    print(#function)
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInitiated)

    queue.async(group: group) {
        print("Job 1 start")
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Job 1 finish")
    }
    
    group.notify(queue: .main) {
        print("All jobs done")
    }

    queue.async(group: group) {
        print("Job 2 start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job 2 finish")
    }
    
    print("End of the \(#function)")
}

func groupNotifyDemo5() {
    print(#function)
    let group = DispatchGroup()
    let queue = DispatchQueue.global(qos: .userInitiated)

    queue.async(group: group) {
        print("Job 1 start")
        print("Job 1 finish")
    }
    
    group.notify(queue: .main) {
        print("All jobs done")
    }

    queue.async(group: group) {
        print("Job 2 start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job 2 finish")
    }
    
    print("End of the \(#function)")
}

func groupNotifyDemo6() {
    print(#function)
    let group = DispatchGroup()
    let queueUserInitiated = DispatchQueue.global(qos: .userInitiated)
    let queueUtility = DispatchQueue.global(qos: .utility)
    let queueBackground = DispatchQueue.global(qos: .background)
    let queueSerialUtility = DispatchQueue(label: "com.volodymyroniuk", qos: .utility)

    queueBackground.async(group: group) {
        print("Job [background] start")
        Thread.sleep(until: Date().addingTimeInterval(10))
        print("Job [background] finish")
    }
    
    queueUtility.async(group: group) {
        print("Job [utility] start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job [utility] finish")
    }
    
    queueUserInitiated.async(group: group) {
        print("Job [user initiated] start")
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Job [user initiated] finish")
    }

    queueSerialUtility.async(group: group) {
        print("Job [serial utility] start")
        Thread.sleep(until: Date().addingTimeInterval(3))
        print("Job [serial utility] finish")
    }

    group.notify(queue: .main) {
        print("All jobs done")
    }
    
    print("End of the \(#function)")
}

//groupNotifyDemo1()
//groupNotifyDemo2()
//groupNotifyDemo3()
//groupNotifyDemo4()
//groupNotifyDemo5()
//groupNotifyDemo6()

// MARK: - DispatchGroup.wait

func groupWaitDemo1() {
    print(#function)
    let group = DispatchGroup()
    let queueUserInitiated = DispatchQueue.global(qos: .userInitiated)
    let queueUtility = DispatchQueue.global(qos: .utility)
    let queueBackground = DispatchQueue.global(qos: .background)
    let queueSerialUtility = DispatchQueue(label: "com.volodymyroniuk", qos: .utility)

    queueBackground.async(group: group) {
        print("Job [background] start")
        Thread.sleep(until: Date().addingTimeInterval(10))
        print("Job [background] finish")
    }
    
    queueUtility.async(group: group) {
        print("Job [utility] start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job [utility] finish")
    }
    
    queueUserInitiated.async(group: group) {
        print("Job [user initiated] start")
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Job [user initiated] finish")
    }

    queueSerialUtility.async(group: group) {
        print("Job [serial utility] start")
        Thread.sleep(until: Date().addingTimeInterval(3))
        print("Job [serial utility] finish")
    }

    if group.wait(timeout: .now() + 15) == .timedOut {
        print("group.wait has timed out")
    } else {
        print("All jobs done")
    }

    print("End of the \(#function)")
}

func groupWaitDemo2() {
    print(#function)
    let group = DispatchGroup()
    let queueUserInitiated = DispatchQueue.global(qos: .userInitiated)
    let queueUtility = DispatchQueue.global(qos: .utility)
    let queueBackground = DispatchQueue.global(qos: .background)
    let queueSerialUtility = DispatchQueue(label: "com.volodymyroniuk", qos: .utility)

    queueBackground.async(group: group) {
        print("Job [background] start")
        Thread.sleep(until: Date().addingTimeInterval(10))
        print("Job [background] finish")
    }
    
    queueUtility.async(group: group) {
        print("Job [utility] start")
        Thread.sleep(until: Date().addingTimeInterval(5))
        print("Job [utility] finish")
    }
    
    queueUserInitiated.async(group: group) {
        print("Job [user initiated] start")
        Thread.sleep(until: Date().addingTimeInterval(2))
        print("Job [user initiated] finish")
    }

    queueSerialUtility.async(group: group) {
        print("Job [serial utility] start")
        Thread.sleep(until: Date().addingTimeInterval(3))
        print("Job [serial utility] finish")
    }

    if group.wait(timeout: .now() + 5) == .timedOut {
        print("group.wait has timed out")
    } else {
        print("All jobs done")
    }

    print("End of the \(#function)")
}

//groupWaitDemo1()
//groupWaitDemo2()

// MARK: - Async method wrapping

func sumAsync(lhs: Int, rhs: Int, completion: @escaping (Int) -> Void) {
    completion(lhs + rhs)
}

func sumAsyncWithGroup(group: DispatchGroup, lhs: Int, rhs: Int, completion: @escaping (Int) -> Void) {
    group.enter()
    
    sumAsync(lhs: lhs, rhs: rhs) { result in
        defer { group.leave() }
        completion(result)
    }
}

let group = DispatchGroup()
sumAsyncWithGroup(group: group, lhs: 3, rhs: 14) { result in
    print(result)
}
