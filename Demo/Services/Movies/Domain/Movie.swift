//
// Copyright © 2021 onsissond. All rights reserved.
//

import Foundation

struct Movie {
    let id: String
    let title: String
}

extension Movie: Decodable {
    enum CodingKeys: String, CodingKey {
        case id = "imdb_id"
        case title
    }
}
