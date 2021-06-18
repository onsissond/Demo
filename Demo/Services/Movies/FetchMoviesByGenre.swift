//
// Copyright © 2021 onsissond. All rights reserved.
//

import Core

class FetchMoviesByGenreOperation: NetworkOperation {
    var moviesResult: Result<[Movie], Error>?

    override var networkResult: Result<(Data, URLResponse), Error>? {
        didSet {
            guard let result = networkResult else { return }
            switch JSONDecoder().decode(MoviesByGenreResponse.self, from: result) {
            case .success(let response):
                self.moviesResult = .success(response.movies)
            case .failure(let error):
                self.moviesResult = .failure(error)
            }
        }
    }

    public init(
        urlSession: URLSession,
        genre: Genre,
        completion: ((Result<[Movie], Error>) -> Void)? = nil
    ) {
        super.init(urlSession: urlSession, urlRequest: .movies(genre: genre))
    }
}

struct MoviesByGenreResponse: Decodable {
    let movies: [Movie]

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let data = try container.decode([String:[Movie]].self)
        movies = data.first?.value ?? []
    }
}

private extension URLRequest {
    static func movies(genre: Genre) -> URLRequest {
        var request = URLRequest(url: URL(
            string: "https://data-imdb1.p.rapidapi.com/movie/byGen/\(genre.name)/"
        )!)
        request.httpMethod = "GET"
        return request
    }
}

