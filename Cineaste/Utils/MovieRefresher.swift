//
//  MovieRefresher.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 07.11.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

enum MovieRefresher {
    static func refresh(movies: [Movie], completionHandler: @escaping (_ progress: NSNumber) -> Void) {
        for (index, movieToUpdate) in movies.enumerated() {
            let networkMovie = Movie(id: movieToUpdate.id)

            Webservice.load(resource: networkMovie.get) { result in
                DispatchQueue.main.async {
                    switch result {
                    case .success(let movie):
                        var updatedMovie = movieToUpdate
                        updatedMovie.update(withNew: movie)
                        store.dispatch(MovieAction.update(movie: updatedMovie))
                    case .failure:
                        break
                    }
                    let progress = NSNumber(value: Double(index + 1) / Double(movies.count))
                    completionHandler(progress)
                }
            }
        }
    }
}
