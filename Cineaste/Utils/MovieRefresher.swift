//
//  MovieRefresher.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 07.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

enum MovieRefresher {
    static func refresh(movies: [Movie], completionHandler: @escaping () -> Void) {
        let group = DispatchGroup()

        for movieToUpdate in movies {
            group.enter()
            let networkMovie = Movie(id: movieToUpdate.id)

            Webservice.load(resource: networkMovie.get) { result in
                switch result {
                case .success(let movie):
                    let updatedMovie = self.update(movieToUpdate, withNew: movie)
                    store.dispatch(MovieAction.update(movie: updatedMovie))
                    group.leave()
                case .failure:
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
    static func update(_ movieToUpdate: Movie, withNew movie: Movie) -> Movie {
        let updatedMovie = Movie(
            id: movie.id,
            title: movie.title,
            voteAverage: movie.voteAverage,
            voteCount: movie.voteCount,
            posterPath: movie.posterPath,
            overview: movie.overview,
            runtime: movie.runtime,
            releaseDate: movie.releaseDate,
            watched: movieToUpdate.watched,
            watchedDate: movieToUpdate.watchedDate,
            popularity: movie.popularity)

        return updatedMovie
    }
}
