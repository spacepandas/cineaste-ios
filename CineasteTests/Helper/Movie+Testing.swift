//
//  Movie+Testing.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 14.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation
@testable import Cineaste_App

extension Movie {
    static let testing = Movie(
        id: 515_042,
        title: "Free Solo",
        voteAverage: 8,
        voteCount: 499,
        posterPath: "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
        overview: "Follow Alex Honnold as he attempts to become the first person to ever free solo climb Yosemite's 3,000 foot high El Capitan wall. With no ropes or safety gear, this would arguably be the greatest feat in rock climbing history.",
        runtime: 100,
        releaseDate: Date(timeIntervalSince1970: 1_539_302_400),
        genres: [
            Genre(id: 99, name: "Documentary")
        ],
        watched: nil,
        watchedDate: nil,
        popularity: 7.582
    )

    static let testingWithoutPosterPath: Movie = {
        Movie(withOutPoster: Movie.testing)
    }()

    static let testingWatchlist = Movie(
        id: 10_898,
        title: "The Little Mermaid II: Return to the Sea",
        voteAverage: 6.3,
        voteCount: 898,
        posterPath: "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg",
        overview: "Set several years after the first film, Ariel and Prince Eric are happily married with a daughter, Melody. In order to protect Melody from the Sea Witch, Morgana, they have not told her about her mermaid heritage. Melody is curious and ventures into the sea, where she meets new friends. But will she become a pawn in Morgana\'s quest to take control of the ocean from King Triton?",
        runtime: 72,
        releaseDate: Date(timeIntervalSince1970: 948_585_600),
        genres: [
            Genre(id: 12, name: "Adventure"),
            Genre(id: 16, name: "Animation"),
            Genre(id: 10_751, name: "Family"),
            Genre(id: 10_402, name: "Music")
        ],
        watched: false,
        watchedDate: nil,
        listPosition: 0,
        popularity: 2.535
    )

    static let testingWatchlistWithoutPosterPath: Movie = {
        Movie(withOutPoster: Movie.testingWatchlist)
    }()

    static let testingWatchlist2 = Movie(
        id: 3,
        title: "Harry Potter",
        voteAverage: 0,
        voteCount: 0,
        posterPath: nil,
        overview: "",
        runtime: 132,
        releaseDate: Date(timeIntervalSince1970: 1_763_589_628),
        genres: [],
        watched: false,
        watchedDate: nil,
        popularity: 448
    )

    static let testingWatchlist2WithoutPosterPath: Movie = {
        Movie(withOutPoster: Movie.testingWatchlist2)
    }()

    static let testingSeen = Movie(
        id: 10_144,
        title: "The Little Mermaid",
        voteAverage: 7.3,
        voteCount: 4_529,
        posterPath: "/y0EOuK02TasfRGSZBdv5U910QaV.jpg",
        overview: "This colorful adventure tells the story of an impetuous mermaid princess named Ariel who falls in love with the very human Prince Eric and puts everything on the line for the chance to be with him. Memorable songs and characters -- including the villainous sea witch Ursula.",
        runtime: 83,
        releaseDate: Date(timeIntervalSince1970: 627_264_000),
        genres: [
            Genre(id: 16, name: "Animation"),
            Genre(id: 10_751, name: "Family"),
            Genre(id: 14, name: "Fantasy")
        ],
        watched: true,
        watchedDate: Date(timeIntervalSince1970: 1_510_951_766),
        listPosition: 0,
        popularity: 2_166
    )

    static let testingSeenWithoutPosterPath: Movie = {
        Movie(withOutPoster: Movie.testingSeen)
    }()
}

private extension Movie {
    init(withOutPoster original: Movie) {
        self = Movie(
            id: original.id,
            title: original.title,
            voteAverage: original.voteAverage,
            voteCount: original.voteAverage,
            posterPath: nil,
            overview: original.overview,
            runtime: original.runtime,
            releaseDate: original.releaseDate,
            genres: original.genres,
            watched: original.watched,
            watchedDate: original.watchedDate,
            popularity: original.popularity
        )
    }
}
