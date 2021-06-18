//
// Copyright © 2021 onsissond. All rights reserved.
//

import Foundation

open class AsyncOperation: Operation {
    var state: State = .ready {
        willSet {
            willChangeValue(forKey: state.keyPath)
            willChangeValue(forKey: newValue.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    public override var isReady: Bool {
        super.isReady && state == .ready
    }

    public override var isExecuting: Bool {
        state == .executing
    }

    public override var isFinished: Bool {
        state == .finished
    }

    public override var isAsynchronous: Bool { true }

    public override func start() {
        if isCancelled {
            state = .finished
            return
        }
        state = .executing
        main()
    }

    public override func cancel() {
        state = .finished
    }
}

extension AsyncOperation {
    enum State: String {
        case ready
        case executing
        case finished

        fileprivate var keyPath: String {
            "is" + rawValue.capitalized
        }
    }
}
