//
//  MovieRefresher.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 07.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Kingfisher

final class MovieRefresher {

    var refreshMode: RefreshMode
    private let fetchedResultsManager = FetchedResultsManager()
    private let storageManager = MovieStorage()

    init(refreshMode: RefreshMode = .wifi) {
        self.refreshMode = refreshMode
    }

    func refreshMoviesInDatabase() {
        guard shouldRefreshMovies,
            let storedMovies = fetchedResultsManager.controller.fetchedObjects
            else { return }

        for storedMovie in storedMovies {
            let networkMovie = Movie(id: storedMovie.id, title: "")

            // TODO: Check out the caching situation
            Webservice.load(resource: networkMovie.get) { result in
                if case let .success(movie) = result {
                    let updatedMovie = StoredMovie(withMovie: movie, context: self.storageManager.backgroundContext)
                    updatedMovie.poster = storedMovie.poster
                    updatedMovie.watched = storedMovie.watched
                    updatedMovie.watchedDate = storedMovie.watchedDate
                    updatedMovie.reloadPosterIfNeeded {
                        self.storageManager.updateMovieItem(with: updatedMovie, watched: storedMovie.watched)
                    }
                }
            }
        }
    }

    private var shouldRefreshMovies: Bool {
        switch refreshMode {
        case .never:
            return false
        case .wifi:
            fatalError("TODO: Find out if the user is on wifi")
        case .always:
            return true
        }
    }
}

extension MovieRefresher {
    enum RefreshMode { case never, wifi, always }
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
