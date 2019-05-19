//
//  FileImporter.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

enum ImportError: Error {
    case noDataAtPath
    case parsingJsonToStoredMovie
}

enum Importer {
    static func importMovies(from path: URL, completion: @escaping ((Result<Int, Error>) -> Void)) {
        guard let data = try? Data(contentsOf: path, options: []) else {
            completion(.failure(ImportError.noDataAtPath))
            return
        }

        let group = DispatchGroup()

        guard let importExportObject = try? JSONDecoder.tmdbDecoder
            .decode(ImportExportObject.self, from: data)
            else {
                completion(.failure(ImportError.parsingJsonToStoredMovie))
                return
        }

        for var movie in importExportObject.movies {
            group.enter()

            movie.reloadPosterIfNeeded { poster in
                movie.poster = poster
                store.dispatch(MovieAction.add(movie: movie))
                group.leave()
            }
        }

        group.notify(queue: DispatchQueue.main) {
            completion(.success(importExportObject.movies.count))
        }
    }
}
