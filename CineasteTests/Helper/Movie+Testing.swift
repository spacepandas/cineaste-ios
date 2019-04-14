//
//  Movie+Testing.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 14.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

@testable import Cineaste_App

extension Movie {
    static let testing = Movie(
        id: 0,
        title: "Free Solo",
        voteAverage: 6.9,
        voteCount: 1_234,
        posterPath: nil,
        overview: "String",
        runtime: 180,
        releaseDate: nil,
        poster: nil,
        watched: nil,
        watchedDate: nil,
        popularity: 444
    )
}
