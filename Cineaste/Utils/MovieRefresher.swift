//
//  MovieRefresher.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 07.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

final class MovieRefresher {
    func refresh(movies: [Movie], completionHandler: @escaping () -> Void) {
        let group = DispatchGroup()

        for movieToUpdate in movies {
            group.enter()
            let networkMovie = Movie(id: movieToUpdate.id)

            Webservice.load(resource: networkMovie.get) { result in
                if case let .success(movie) = result {
                    self.update(movieToUpdate, withNew: movie) { updatedMovie in
                        store.dispatch(MovieAction.update(movie: updatedMovie))
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

private extension MovieRefresher {
    func update(_ movieToUpdate: Movie, withNew movie: Movie, completion: @escaping (Movie) -> Void) {
        var updatedMovie = Movie(
            id: movie.id,
            title: movie.title,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            posterPath: movie.posterPath,
            overview: movie.overview,
            runtime: movie.runtime,
            releaseDate: movie.releaseDate,
            poster: movieToUpdate.poster,
            watched: movieToUpdate.watched,
            watchedDate: movieToUpdate.watchedDate,
            popularity: movie.popularity)

        updatedMovie.reloadPosterIfNeeded { image in
            updatedMovie.poster = image
            completion(updatedMovie)
        }
    }
}
