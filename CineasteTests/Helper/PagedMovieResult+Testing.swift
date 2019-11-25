//
//  PagedMovieResult+Testing.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 25.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

@testable import Cineaste_App

extension PagedMovieResult {
    static let testing = PagedMovieResult(
        page: 1,
        totalResults: 1,
        totalPages: 1,
        results: [Movie.testing]
    )
}
