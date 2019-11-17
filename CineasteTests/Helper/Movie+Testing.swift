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
        overview:
        //swiftlint:disable line_length
        """
        Er hörte leise Schritte hinter sich. Das bedeutete nichts Gutes. Wer würde ihm schon folgen, spät in der Nacht und dazu noch in dieser engen Gasse mitten im übel beleumundeten Hafenviertel? Gerade jetzt, wo er das Ding seines Lebens gedreht hatte und mit der Beute verschwinden wollte! Hatte einer seiner zahllosen Kollegen dieselbe Idee gehabt, ihn beobachtet und abgewartet, um ihn nun um die Früchte seiner Arbeit zu erleichtern? Oder gehörten die Schritte hinter ihm zu einem der unzähligen Gesetzeshüter dieser Stadt, und die stählerne Acht um seine Handgelenke würde gleich zuschnappen? Er konnte die Aufforderung stehen zu bleiben schon hören. Gehetzt sah er sich um. Plötzlich erblickte er den schmalen Durchgang. Blitzartig drehte er sich nach rechts und verschwand zwischen den beiden Gebäuden. Beinahe wäre er dabei über den umgestürzten Mülleimer gefallen, der mitten im Weg lag. Er versuchte, sich in der Dunkelheit seinen Weg zu ertasten und erstarrte: Anscheinend gab es keinen anderen Ausweg aus diesem kleinen Hof als den Durchgang, durch den er gekommen war. Die Schritte wurden lauter und lauter, er sah eine dunkle Gestalt um die Ecke biegen. Fieberhaft irrten seine Augen durch die nächtliche Dunkelheit und suchten einen Ausweg. War jetzt wirklich alles vorbei...
        """,
        runtime: 180,
        releaseDate: nil,
        watched: nil,
        watchedDate: nil,
        popularity: 444
    )

    static let testingWatchlist = Movie(
        id: 10_144,
        title: "The Little Mermaid",
        voteAverage: 7.3,
        voteCount: 4_529,
        posterPath: "/6aXMusULuKFAK0ZRUlv7RJ9zHTc.jpg",
        overview: "This colorful adventure tells the story of an impetuous mermaid princess named Ariel who falls in love with the very human Prince Eric and puts everything on the line for the chance to be with him. Memorable songs and characters -- including the villainous sea witch Ursula.",
        runtime: 83,
        releaseDate: Date(timeIntervalSinceNow: -351_043_200),
        watched: false,
        watchedDate: nil,
        popularity: 19_372
    )

    static let testingWatchlist2 = Movie(
        id: 10_898,
        title: "The Little Mermaid II: Return to the Sea",
        voteAverage: 6.3,
        voteCount: 898,
        posterPath: "/1P7zIGdv3Z0A5L6F30Qx0r69cmI.jpg",
        overview: "Set several years after the first film, Ariel and Prince Eric are happily married with a daughter, Melody. In order to protect Melody from the Sea Witch, Morgana, they have not told her about her mermaid heritage. Melody is curious and ventures into the sea, where she meets new friends. But will she become a pawn in Morgana\'s quest to take control of the ocean from King Triton?",
        runtime: 72,
        releaseDate: Date(timeIntervalSinceNow: -10_713_600),
        watched: false,
        watchedDate: nil,
        popularity: 2_166
    )

    static let testingSeen = Movie(
        id: 3,
        title: "Harry Potter",
        voteAverage: 7.4,
        voteCount: 1_234,
        posterPath: nil,
        overview: "",
        runtime: 132,
        releaseDate: nil,
        watched: true,
        watchedDate: Date(timeIntervalSince1970: 1_574_023_766),
        popularity: 444
    )
}
