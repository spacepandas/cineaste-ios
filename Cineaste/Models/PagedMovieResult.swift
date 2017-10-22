//
//  PagedMovieResult.swift
//  Cineaste
//
//  Created by Christian Braun on 22.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

struct PagedMovieResult: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: [Movie]
    
    enum CodingKeys: String, CodingKey {
        case page
        case totalResults = "total_results"
        case totalPages = "total_pages"
        case results
    }
}
