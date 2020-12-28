//
//  Persistence.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 17.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation
import WidgetKit

enum Persistence {
    static func saveMovies(_ movies: Set<Movie>) throws {
        let data = try JSONEncoder.tmdbEncoder.encode(movies)
        try data.write(to: movieUrl)

        // make Movies available for Widgets
        try data.write(to: storeUrl)
        if #available(iOS 14, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }

    static func loadMovies() -> Set<Movie> {
        guard let data = try? Data(contentsOf: movieUrl) else { return [] }
        let movies = try? JSONDecoder().decode(Set<Movie>.self, from: data)
        return movies ?? []
    }

    static func urlForMovieExport() throws -> URL {
        let movies = loadMovies()
        let data = try JSONEncoder.tmdbEncoder.encode(ImportExportObject(movies: movies))
        try data.write(to: exportMovieUrl)
        return exportMovieUrl
    }
}

private extension Persistence {
    static let movieUrl = FileManager.default.documentsDirectory
        .appendingPathComponent("movies.json")
    static let storeUrl = AppGroup.widget.containerURL
        .appendingPathComponent("movies.json")
    static let exportMovieUrl = FileManager.default.cachesDirectory
        .appendingPathComponent("cineaste-\(Current.date().formattedForRequest).json")
}

private extension FileManager {
    var documentsDirectory: URL {
        // swiftlint:disable:next force_try
        return try! url(
            for: .documentDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }

    var cachesDirectory: URL {
        // swiftlint:disable:next force_try
        return try! url(
            for: .cachesDirectory,
            in: .userDomainMask,
            appropriateFor: nil,
            create: false
        )
    }
}
