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
    case parsingJsonToImportExport
}

enum Importer {
    static func importMovies(from url: URL, completion: @escaping ((Result<Int, ImportError>) -> Void)) {
        guard let data = try? Data(contentsOf: url, options: [])
        else {
            completion(.failure(ImportError.noDataAtPath))
            return
        }

        guard let importExportObject = try? JSONDecoder()
                .decode(ImportExportObject.self, from: data)
        else {
            completion(.failure(ImportError.parsingJsonToImportExport))
            return
        }

        let moviesToImport = importExportObject.movies
        for movie in moviesToImport {
            store.dispatch(MovieAction.add(movie: movie))
        }

        // update all imported movies asynchronously
        MovieRefresher.refresh(movies: Array(moviesToImport)) {
            completion(.success(moviesToImport.count))
        }
    }
}
