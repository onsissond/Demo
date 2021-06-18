//
// Copyright © 2021 onsissond. All rights reserved.
//

import Foundation

struct Genre {
    let name: String
}

extension Genre: Decodable {
    enum CodingKeys: String, CodingKey {
        case name = "genre"
    }
}
