import Cocoa
import PlaygroundSupport

PlaygroundPage.current.needsIndefiniteExecution = true

class AsyncOperation: Operation {
    var state: State = .ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }
    
    override var isReady: Bool {
        super.isReady && state == .ready
    }
    
    override var isExecuting: Bool {
        state == .executing
    }
    
    override var isFinished: Bool {
        state == .finished
    }
    
    override var isAsynchronous: Bool {
        true
    }
    
    override func start() {
        main()
        state = .executing
    }
}

extension AsyncOperation {
    enum State: String {
        case ready, executing, finished
        
        fileprivate var keyPath: String {
            "is\(rawValue.capitalized)"
        }
    }
}

final class AsyncSumOperation: AsyncOperation {
    private let lhs: Int
    private let rhs: Int
    private(set) var result: Int?
    
    init(lhs: Int, rhs: Int) {
        self.lhs = lhs
        self.rhs = rhs
        
        super.init()
    }
    
    override func main() {
        DispatchQueue.global().async {
            Thread.sleep(forTimeInterval: 2)
            self.result = self.lhs + self.rhs
            self.state = .finished
        }
    }
}

let operationQueue = OperationQueue()
let pairs = [(1, 2), (5, 4), (13, 21), (22, 48), (34, 56), (12, 23), (99, 99)]

for pair in pairs {
    let sumOperation = AsyncSumOperation(lhs: pair.0, rhs: pair.1)
    sumOperation.completionBlock = {
        guard let result = sumOperation.result else { return }
        print("\(pair.0) + \(pair.1) = \(result)")
    }
    
    operationQueue.addOperation(sumOperation)
}

operationQueue.waitUntilAllOperationsAreFinished()
