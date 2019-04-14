//
//  MovieReducerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import ReSwift
@testable import Cineaste_App

class MovieReducerTests: XCTestCase {

    func testLoadMovieActionShouldPopulateState() {
        // Given
        let before = AppState()
        let movie = Movie(id: 0, title: "Dirty Dancing")
        let action = MovieAction.load(movies: [movie])

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.movies.count, 1)
        XCTAssertEqual(after.movies, [movie])
    }

    func testAddMovieActionShouldInsertMovie() {
        // Given
        let movie = Movie(id: 0, title: "Free Solo")
        let before = AppState(movies: [movie], selectedMovieId: nil)

        let movieToInsert = Movie(id: 1, title: "Dirty Dancing")
        let action = MovieAction.add(movie: movieToInsert)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.movies.count, 2)
        XCTAssert(after.movies.contains(movie))
        XCTAssert(after.movies.contains(movieToInsert))
    }

    func testUpdateMovieActionShouldUpdateExistingMovie() {
        // Given
        var movie = Movie(id: 0, title: "Free Solo")
        movie.watched = false
        let before = AppState(movies: [movie], selectedMovieId: nil)

        movie.watched = true
        let action = MovieAction.update(movie: movie)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.movies.count, 1)
        XCTAssert(after.movies.first!.watched)
    }

    func testDeleteMovieActionShouldDeleteExistingMovie() {
        // Given
        let movie = Movie(id: 0, title: "Free Solo")
        let movie2 = Movie(id: 1, title: "Shoplifters")
        let before = AppState(movies: [movie, movie2], selectedMovieId: nil)

        let action = MovieAction.delete(movie: movie2)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.movies.count, 1)
        XCTAssert(after.movies.contains(movie))
        XCTAssertFalse(after.movies.contains(movie2))
    }

    func testSelectMovieActionShouldSelectMovie() {
        // Given
        let movie = Movie(id: 0, title: "Free Solo")
        let before = AppState(movies: [movie], selectedMovieId: nil)
        XCTAssertNil(before.selectedMovieId)

        let action = MovieAction.select(movie: movie)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertNotNil(after.selectedMovieId)
        XCTAssertEqual(after.selectedMovieId, movie.id)
    }

}
