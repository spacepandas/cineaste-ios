//
//  FileImporter.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 25.12.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import Foundation

enum ImportError: Error {
    case noDataAtPath
    case parsingJsonToStoredMovie
    case savingNewMovies
}

enum Importer {
    static func importMovies(from path: URL, storageManager: MovieStorage, completion: @escaping ((Result<Int>) -> Void)) {
        Importer.decodeMovies(from: path, with: storageManager) { result in
            switch result {
            case .error(let error):
                completion(.error(error))
            case .success(let movies):
                Importer.save(movies, with: storageManager, completion: completion)
            }
        }
    }
}

extension Importer {
    private static func decodeMovies(from path: URL, with storageManager: MovieStorage, completion: @escaping ((Result<[StoredMovie]>) -> Void)) {
        guard let data = try? Data(contentsOf: path, options: []) else {
            completion(.error(ImportError.noDataAtPath))
            return
        }

        do {
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = storageManager.backgroundContext

            let importExportObject = try decoder.decode(ImportExportObject.self,
                                                        from: data)
            completion(.success(importExportObject.movies))
        } catch {
            completion(.error(ImportError.parsingJsonToStoredMovie))
        }
    }

    private static func save(_ movies: [StoredMovie], with storageManager: MovieStorage, completion: @escaping ((Result<Int>) -> Void)) {
        let dispatchGroup = DispatchGroup()

        //load all posters
        for movie in movies {
            dispatchGroup.enter()

            movie.loadPoster { poster in
                if let poster = poster {
                    movie.poster = poster
                }

                dispatchGroup.leave()
            }
        }

        dispatchGroup.notify(queue: .global()) {
            storageManager.updateMovieItems(with: movies) { result in
                switch result {
                case .success:
                    completion(.success(movies.count))
                case .error:
                    completion(.error(ImportError.savingNewMovies))
                }
            }
        }
    }
}
