//
//  MovieThunksTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 20.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
@testable import ReSwiftThunk
@testable import Cineaste_App

class MovieThunksTests: XCTestCase {

    func testUpdateMovieAsWatchedShouldSetWatchedAndWatchedDate() {
        // Given
        let movie = Movie.testingWatchlist
        let thunk = updateMovie(with: movie, markAsWatched: true)

        var updatedMovie = movie
        updatedMovie.watched = true
        updatedMovie.watchedDate = Date()
        let expectedAction = MovieAction.update(movie: updatedMovie)
        var actions: [Action] = []
        store.dispatchFunction = { XCTFail("\($0)") }

        // When
        thunk.body({ actions.append($0) }, { AppState() })

        // Then
        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(String(describing: actions[0]),
                       String(describing: expectedAction))
    }

    func testUpdateMovieAsSeenShouldSetWatchedAndWatchedDate() {
        // Given
        let movie = Movie.testingSeen
        let thunk = updateMovie(with: movie, markAsWatched: false)

        var updatedMovie = movie
        updatedMovie.watched = false
        let expectedAction = MovieAction.update(movie: updatedMovie)
        var actions: [Action] = []
        store.dispatchFunction = { XCTFail("\($0)") }

        // When
        thunk.body({ actions.append($0) }, { AppState() })

        // Then
        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(String(describing: actions[0]),
                       String(describing: expectedAction))
    }

}
