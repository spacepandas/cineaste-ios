//
//  PagedMovieResult.swift
//  Cineaste
//
//  Created by Christian Braun on 22.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

struct PagedMovieResult: Equatable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: Set<Movie>
}

extension PagedMovieResult: Codable {
    private enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
