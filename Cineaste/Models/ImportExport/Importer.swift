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
    static func importMovies(from url: URL) throws -> Int {
        guard let data = try? Data(contentsOf: url, options: [])
            else { throw ImportError.noDataAtPath }

        guard let importExportObject = try? JSONDecoder.tmdbDecoder
            .decode(ImportExportObject.self, from: data)
            else { throw ImportError.parsingJsonToStoredMovie }

        for movie in importExportObject.movies {
            store.dispatch(MovieAction.add(movie: movie))
        }

        return importExportObject.movies.count
    }
}
