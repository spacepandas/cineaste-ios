//
//  MovieRefresher.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 07.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

enum MovieRefresher {
    static func refresh(movies: [Movie], completionHandler: @escaping () -> Void) {
        let group = DispatchGroup()

        for movieToUpdate in movies {
            group.enter()
            let networkMovie = Movie(id: movieToUpdate.id)

            Webservice.load(resource: networkMovie.get) { result in
                switch result {
                case .success(let movie):
                    var updatedMovie = movieToUpdate
                    updatedMovie.update(withNew: movie)
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
