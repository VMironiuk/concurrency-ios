//
//  AsyncOperation.swift
//  Concurrency
//
//  Created by Vladimir Mironiuk on 20.06.2022.
//

import Foundation

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
            "is\(self.rawValue.capitalized)"
        }
    }
}
