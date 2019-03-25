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
    static func importMovies(from path: URL, storageManager: MovieStorageManager, completion: @escaping ((Result<Int, Error>) -> Void)) {
        guard let data = try? Data(contentsOf: path, options: []) else {
            completion(.failure(ImportError.noDataAtPath))
            return
        }

        let group = DispatchGroup()

        storageManager.backgroundContext.performChanges {
            let decoder = JSONDecoder()
            decoder.userInfo[.context] = storageManager.backgroundContext

            guard let importExportObject = try? decoder
                .decode(ImportExportObject.self, from: data)
                else {
                    completion(.failure(ImportError.parsingJsonToStoredMovie))
                    return
            }

            //load all posters
            for movie in importExportObject.movies {
                group.enter()

                movie.reloadPosterIfNeeded {
                    group.leave()
                }
            }

            group.wait()
            DispatchQueue.main.async {
                completion(.success(importExportObject.movies.count))
            }
        }
    }
}
