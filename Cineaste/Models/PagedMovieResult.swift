//
//  PagedMovieResult.swift
//  Cineaste
//
//  Created by Christian Braun on 22.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

struct PagedMovieResult: Codable {
    let page: Int
    let totalResults: Int
    let totalPages: Int
    let results: Set<Movie>
}
