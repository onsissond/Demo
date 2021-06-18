//
// Copyright © 2021 onsissond. All rights reserved.
//

import Foundation

open class NetworkOperation: AsyncOperation {
    private let _urlSession: URLSession
    private let _urlRequest: URLRequest
    private var _task: URLSessionDataTask?
    open var networkResult: Result<(Data, URLResponse), Error>?

    public init(
        urlSession: URLSession,
        urlRequest: URLRequest
    ) {
        _urlSession = urlSession
        _urlRequest = urlRequest
    }

    public override func cancel() {
        super.cancel()
        _task?.cancel()
    }

    public override func main() {
        _task = _urlSession.dataTask(with: _urlRequest) { [weak self] data, response, error in
            print("SOS \(Date())")
            guard let self = self else { return }
            guard !self.isCancelled else { return }
            defer { self.state = .finished }
            if let error = error {
                self.networkResult = .failure(error)
            }
            if let data = data, let response = response {
                self.networkResult = .success((data, response))
            }
        }
        _task?.resume()
    }
}
