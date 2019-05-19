//
//  Movie.swift
//  Cineaste
//
//  Created by Christian Braun on 18.10.17.
//  Copyright notimeforthat.org. All rights reserved.
//

import UIKit
import CoreData

struct Movie: Codable, Equatable {
    let id: Int64
    let title: String
    let voteAverage: Double
    let voteCount: Double
    let posterPath: String?
    let overview: String
    let runtime: Int16?
    var releaseDate: Date?
//    var poster: UIImage?

    //swiftlint:disable:next discouraged_optional_boolean
    var watched: Bool?
    var watchedDate: Date?

    var listPosition: Int?

    let popularity: Double?

    // This is only for creating a movie to use it with the webservice
    init(id: Int64) {
        self.id = id
        self.title = ""
        voteAverage = 0
        voteCount = 0
        overview = ""
        runtime = 0
        posterPath = nil
        popularity = 0
    }

    init(id: Int64,
         title: String,
         voteAverage: Double,
         voteCount: Double,
         posterPath: String?,
         overview: String,
         runtime: Int16?,
         releaseDate: Date?,
         poster: UIImage?,
         //swiftlint:disable:next discouraged_optional_boolean
         watched: Bool?,
         watchedDate: Date?,
         listPosition: Int? = 0,
         popularity: Double?) {
        self.id = id
        self.title = title
        self.voteAverage = voteAverage
        self.voteCount = voteCount
        self.posterPath = posterPath
        self.overview = overview
        self.runtime = runtime
        self.releaseDate = releaseDate
        self.watched = watched
        self.watchedDate = watchedDate
        self.listPosition = listPosition
        self.popularity = popularity

        self.poster = poster
    }
}

extension Movie: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    var poster: UIImage? {
        get { return nil }
        set { }
    }
}
