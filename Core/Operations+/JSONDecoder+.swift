//
// Copyright © 2021 onsissond. All rights reserved.
//

import Foundation

extension JSONDecoder {
    open func decode<T>(
        _ type: T.Type,
        from result: Result<(Data, URLResponse), Error>
    ) -> Result<T, Error> where T : Decodable {
        switch result {
        case .success(let (data, _)):
            do {
                let result = try decode(type, from: data)
                return .success(result)
            } catch {
                return .failure(error)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}
