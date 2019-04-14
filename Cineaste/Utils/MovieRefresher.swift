//
//  MovieRefresher.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 07.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

final class MovieRefresher {
    private let storageManager: MovieStorageManager

    init(with storageManager: MovieStorageManager) {
        self.storageManager = storageManager
    }

    func refresh(movies: [StoredMovie], completionHandler: @escaping () -> Void) {
        let group = DispatchGroup()

        storageManager.backgroundContext.performChanges {
            for storedMovie in movies {
                group.enter()
                let networkMovie = Movie(id: storedMovie.id)

                Webservice.load(resource: networkMovie.get) { result in
                    if case let .success(movie) = result {
                        self.update(storedMovie, withNew: movie) {
                            group.leave()
                        }
                    } else {
                        group.leave()
                    }
                }
            }

            group.wait()
            DispatchQueue.main.async {
                completionHandler()
            }
        }
    }
}

private extension MovieRefresher {
     func update(_ storedMovie: StoredMovie, withNew movie: Movie, completion: @escaping () -> Void) {
        guard let updatedMovie = self.storageManager
            .backgroundContext
            .object(with: storedMovie.objectID)
            as? StoredMovie
            else {
                fatalError("Object could not be casted to StoredMovie")
        }

        if updatedMovie.id != movie.id {
            updatedMovie.id = movie.id
        }
        if updatedMovie.title != movie.title {
            updatedMovie.title = movie.title
        }
        if updatedMovie.overview != movie.overview {
            updatedMovie.overview = movie.overview
        }

        if updatedMovie.posterPath != movie.posterPath {
            updatedMovie.posterPath = movie.posterPath
        }

        if updatedMovie.releaseDate != movie.releaseDate {
            updatedMovie.releaseDate = movie.releaseDate
        }
        if updatedMovie.runtime != movie.runtime {
            updatedMovie.runtime = movie.runtime
        }
        if updatedMovie.voteAverage != movie.voteAverage {
            updatedMovie.voteAverage = movie.voteAverage
        }
        if updatedMovie.voteCount != movie.voteCount {
            updatedMovie.voteCount = movie.voteCount
        }

        updatedMovie.reloadPosterIfNeeded {
            completion()
        }
    }
}
