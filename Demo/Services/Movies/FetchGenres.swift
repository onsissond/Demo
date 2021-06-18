//
// Copyright © 2021 onsissond. All rights reserved.
//

import Foundation
import Core

class FetchGenresOperation: NetworkOperation {
    var genresResult: Result<[Genre], Error>?
    override var networkResult: Result<(Data, URLResponse), Error>? {
        didSet {
            guard let result = networkResult else { return }
            switch JSONDecoder().decode(GenresResponse.self, from: result) {
            case .success(let response):
                self.genresResult = .success(response.genres)
            case .failure(let error):
                self.genresResult = .failure(error)
            }
        }
    }

    public init(
        urlSession: URLSession
    ) {
        super.init(urlSession: urlSession, urlRequest: .genre)
    }
}

struct GenresResponse: Decodable {
    let genres: [Genre]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode([String:[Genre]].self)
        genres = data.first?.value ?? []
    }
}

private extension URLRequest {
    static var genre: URLRequest {
        var request = URLRequest(url: URL(string: "https://data-imdb1.p.rapidapi.com/genres/")!)
        request.httpMethod = "GET"
        return request
    }
}

