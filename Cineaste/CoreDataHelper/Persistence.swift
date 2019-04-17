//
//  Persistence.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 17.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

private let movieUrl = FileManager.default.documentsDirectory.appendingPathComponent("movies.json")

enum Persistence {
    static func saveMovies(_ movies: Set<Movie>) throws {
        let data = try JSONEncoder().encode(movies)
        try data.write(to: movieUrl)
    }

    static func loadMovies() -> Set<Movie> {
        guard let data = try? Data(contentsOf: movieUrl) else { return [] }
        let movies = try? JSONDecoder().decode(Set<Movie>.self, from: data)
        return movies ?? []
    }
}

private extension FileManager {
    var documentsDirectory: URL {
        // swiftlint:disable:next force_try
        return try! url(for: .documentDirectory,
                        in: .userDomainMask,
                        appropriateFor: nil,
                        create: false)
    }
}
