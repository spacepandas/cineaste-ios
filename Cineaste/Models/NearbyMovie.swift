//
//  NearbyMovie.swift
//  Cineaste
//
//  Created by Christian Braun on 20.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

struct NearbyMovie: Codable {
    let id: Int64
    let title: String
    let posterPath: String?

    // these three values are only visible in the android app
    var releaseDate: Date?
    var voteAverage: Double = 0
    var runtime: Int16?
}

extension NearbyMovie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension NearbyMovie: Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
}

extension NearbyMovie {
    init(with movie: Movie) {
        id = movie.id
        title = movie.title
        posterPath = movie.posterPath

        releaseDate = movie.releaseDate
        voteAverage = movie.voteAverage
        runtime = movie.runtime
    }
}
