//
//  Movie+Testing.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Foundation

extension Movie {
    static let testMovie = Movie(
        id: 1,
        title: "The New Movie",
        voteAverage: 8,
        voteCount: 499,
        posterPath: "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
        overview: "",
        runtime: 100,
        releaseDate: Date() + 6 * 24 * 60 * 60,
        genres: [
            Genre(id: 99, name: "Documentary")
        ],
        watched: nil,
        watchedDate: nil,
        popularity: 7.582
    )
}
