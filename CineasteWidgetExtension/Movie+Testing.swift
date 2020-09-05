//
//  Movie+Testing.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Foundation

extension Movie {
    static let testSeen = Movie(
        id: 515_042,
        title: "Free Solo",
        voteAverage: 8,
        voteCount: 499,
        posterPath: "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
        // swiftlint:disable:next line_length
        overview: "Follow Alex Honnold as he attempts to become the first person to ever free solo climb Yosemite's 3,000 foot high El Capitan wall. With no ropes or safety gear, this would arguably be the greatest feat in rock climbing history.",
        runtime: 100,
        releaseDate: Date() + 24 * 60 * 60 + 1,
        genres: [
            Genre(id: 99, name: "Documentary")
        ],
        watched: nil,
        watchedDate: nil,
        popularity: 7.582
    )
}
