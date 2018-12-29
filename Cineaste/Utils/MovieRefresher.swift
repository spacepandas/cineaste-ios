//
//  MovieRefresher.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 07.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Kingfisher

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
                let networkMovie = Movie(id: storedMovie.id, title: "")

                Webservice.load(resource: networkMovie.get) { result in
                    if case let .success(movie) = result {
                        guard let updatedMovie = self.storageManager
                            .backgroundContext
                            .object(with: storedMovie.objectID)
                            as? StoredMovie
                            else {
                                fatalError("Object could not be casted to StoredMovie")
                        }

                        updatedMovie.id = movie.id
                        updatedMovie.title = movie.title
                        updatedMovie.overview = movie.overview

                        updatedMovie.posterPath = movie.posterPath

                        updatedMovie.releaseDate = movie.releaseDate
                        updatedMovie.runtime = movie.runtime
                        updatedMovie.voteAverage = movie.voteAverage
                        updatedMovie.voteCount = movie.voteCount

                        updatedMovie.reloadPosterIfNeeded {
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

private extension StoredMovie {

    func reloadPosterIfNeeded(completion: @escaping () -> Void) {
        guard poster == nil, let posterPath = posterPath else {
            completion()
            return
        }

        let url = Movie.posterUrl(from: posterPath, for: .small)
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.poster = data
            completion()
        }
        task.resume()
    }
}
