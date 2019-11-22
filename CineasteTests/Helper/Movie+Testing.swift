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
        id: 515_042,
        title: "Free Solo",
        voteAverage: 8,
        voteCount: 499,
        posterPath: "/v4QfYZMACODlWul9doN9RxE99ag.jpg",
        overview: "Follow Alex Honnold as he attempts to become the first person to ever free solo climb Yosemite's 3,000 foot high El Capitan wall. With no ropes or safety gear, this would arguably be the greatest feat in rock climbing history.",
        runtime: 100,
        releaseDate: Date(timeIntervalSince1970: 1_539_302_400),
        watched: nil,
        watchedDate: nil,
        popularity: 7.582
    )

    static let testingWatchlist = Movie(
        id: 10_898,
        title: "The Little Mermaid II: Return to the Sea",
        voteAverage: 6.3,
        voteCount: 898,
        posterPath: "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg",
        overview: "Set several years after the first film, Ariel and Prince Eric are happily married with a daughter, Melody. In order to protect Melody from the Sea Witch, Morgana, they have not told her about her mermaid heritage. Melody is curious and ventures into the sea, where she meets new friends. But will she become a pawn in Morgana\'s quest to take control of the ocean from King Triton?",
        runtime: 72,
        releaseDate: Date(timeIntervalSince1970: 948_585_600),
        watched: nil,
        watchedDate: nil,
        popularity: 2.535
    )

    static let testingWatchlist2 = Movie(
        id: 3,
        title: "Harry Potter",
        voteAverage: 0,
        voteCount: 0,
        posterPath: nil,
        overview: "",
        runtime: 132,
        releaseDate: Date(timeIntervalSince1970: 1_763_589_628),
        watched: false,
        watchedDate: nil,
        popularity: 448
    )

    static let testingSeen = Movie(
        id: 10_144,
        title: "The Little Mermaid",
        voteAverage: 7.3,
        voteCount: 4_529,
        posterPath: nil,
        overview: "This colorful adventure tells the story of an impetuous mermaid princess named Ariel who falls in love with the very human Prince Eric and puts everything on the line for the chance to be with him. Memorable songs and characters -- including the villainous sea witch Ursula.",
        runtime: 83,
        releaseDate: Date(timeIntervalSince1970: 1_041_717_321),
        watched: true,
        watchedDate: Date(timeIntervalSince1970: 1_510_951_766),
        popularity: 2_166
    )
}
