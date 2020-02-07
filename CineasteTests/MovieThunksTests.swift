//
//  MovieThunksTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 20.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
@testable import ReSwift_Thunk
@testable import Cineaste_App

class MovieThunksTests: XCTestCase {

    func testUpdateMovieAsWatchedShouldSetWatchedAndWatchedDate() {
        // Given
        let movieToUpdate = Movie.testingWatchlist
        let thunk = markMovie(movieToUpdate, watched: true)

        var appState = AppState()
        appState.movies = [movieToUpdate, Movie.testingWatchlist2]

        var updatedMovie = movieToUpdate
        updatedMovie.watched = true
        updatedMovie.watchedDate = Date()
        let expectedAction = MovieAction.update(movie: updatedMovie)
        var actions: [Action] = []
        store.dispatchFunction = { XCTFail("\($0)") }

        // When
        thunk.body({ actions.append($0) }, { appState })

        // Then
        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(
            String(describing: actions[0]),
            String(describing: expectedAction)
        )
    }

    func testUpdateMovieAsSeenShouldSetWatchedAndWatchedDate() {
        // Given
        let movieToUpdate = Movie.testingSeen
        let thunk = markMovie(movieToUpdate, watched: false)

        var appState = AppState()
        appState.movies = [movieToUpdate, Movie.testingWatchlist2]

        var updatedMovie = movieToUpdate
        updatedMovie.watched = false
        let expectedAction = MovieAction.update(movie: updatedMovie)
        var actions: [Action] = []
        store.dispatchFunction = { XCTFail("\($0)") }

        // When
        thunk.body({ actions.append($0) }, { appState })

        // Then
        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(
            String(describing: actions[0]),
            String(describing: expectedAction)
        )
    }

    func testUpdateMovieAsWatchedShouldAddMovieWhenNotExisting() {
        // Given
        let movieToAdd = Movie.testingWatchlist
        let thunk = markMovie(movieToAdd, watched: true)

        var updatedMovie = movieToAdd
        updatedMovie.watched = true
        updatedMovie.watchedDate = Date()
        let expectedAction = MovieAction.add(movie: updatedMovie)
        var actions: [Action] = []
        store.dispatchFunction = { XCTFail("\($0)") }

        // When
        thunk.body({ actions.append($0) }, { AppState() })

        // Then
        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(
            String(describing: actions[0]),
            String(describing: expectedAction)
        )
    }

    func testDeleteMovieShouldDispatchAction() {
        // Given
        let movieToDelete = Movie.testingWatchlist
        let thunk = deleteMovie(movieToDelete)

        var appState = AppState()
        appState.movies = [movieToDelete]

        let expectedAction = MovieAction.delete(movie: movieToDelete)
        var actions: [Action] = []
        store.dispatchFunction = { XCTFail("\($0)") }

        // When
        thunk.body({ actions.append($0) }, { appState })

        // Then
        XCTAssertEqual(actions.count, 1)
        XCTAssertEqual(
            String(describing: actions[0]),
            String(describing: expectedAction)
        )
    }
}
