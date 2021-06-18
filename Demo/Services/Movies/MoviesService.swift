//
// Copyright © 2021 onsissond. All rights reserved.
//

import Combine
import Core

// https://rapidapi.com/SAdrian/api/data-imdb1/
struct MoviesService {
    private var _operationQueue: OperationQueue  = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 6
        return queue
    }()
    var fetchGenres: (_ completion: @escaping (Result<[Genre], Error>) -> Void) -> Void
    var fetchMovies: (_ completion: @escaping (Result<[Movie], Error>) -> Void) -> Void
}

extension MoviesService {
    init(urlSession: URLSession) {
        fetchGenres = { [_operationQueue] completion in
            let operation = FetchGenresOperation(urlSession: urlSession)
            operation.completionBlock = {
                guard let genresResult = operation.genresResult else { return }
                completion(genresResult)
            }
            _operationQueue.addOperation(operation)
        }
        fetchMovies = { [_operationQueue] completion in
            let fetchGenres = FetchGenresOperation(
                urlSession: urlSession
            )
            fetchGenres.completionBlock = {
                switch fetchGenres.genresResult {
                case .success(let genres):
                    let loadMoviesOperations = genres.map {
                        FetchMoviesByGenreOperation(
                            urlSession: urlSession,
                            genre: $0
                        )
                    }
                    let completionOperation = BlockOperation {
                        completion(.success(
                            loadMoviesOperations
                                .compactMap(\.moviesResult?.success)
                                .map { $0.prefix(3) }
                                .flatMap { $0 }
                        ))
                    }
                    loadMoviesOperations.forEach(completionOperation.addDependency)
                    _operationQueue.addOperations(
                        loadMoviesOperations + [completionOperation],
                        waitUntilFinished: false
                    )
                case .failure(let error):
                    completion(.failure(error))
                case .none:
                    return
                }
            }
            _operationQueue.addOperation(fetchGenres)
        }
    }
}

extension URLSession {
    static var dataImdb: URLSession {
        let config = URLSessionConfiguration.default
        config.httpAdditionalHeaders = [
            "x-rapidapi-key": "a4b895ef5bmshaa39f08a005676ep1b0080jsnbef88d9a14d9",
            "x-rapidapi-host": "data-imdb1.p.rapidapi.com"
        ]
        return URLSession(configuration: config)
    }
}

private extension Result {
    var success: Success? {
        switch self {
        case .success(let value):
            return value
        case .failure:
            return nil
        }
    }
}
