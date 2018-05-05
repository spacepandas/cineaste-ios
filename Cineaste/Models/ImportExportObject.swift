//
//  Export.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 05.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

class ImportExportObject: Codable {
    var movies: [StoredMovie]

    init(with movies: [StoredMovie]) {
        self.movies = movies
    }

    enum CodingKeys: String, CodingKey {
        case movies
    }
}
