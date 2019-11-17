//
//  MovieReducerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import ReSwift
@testable import Cineaste_App

class MovieReducerTests: XCTestCase {

    func testAddMovieActionShouldInsertMovie() {
        // Given
        let movie = Movie(id: 0)
        let before: Set<Movie> = [movie]

        let movieToInsert = Movie(id: 1)
        let action = MovieAction.add(movie: movieToInsert)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.count, 2)
        XCTAssert(after.contains(movie))
        XCTAssert(after.contains(movieToInsert))
    }

    func testUpdateMovieActionShouldUpdateExistingMovie() {
        // Given
        var movie = Movie(id: 0)
        movie.watched = false
        let before: Set<Movie> = [movie]

        movie.watched = true
        let action = MovieAction.update(movie: movie)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.count, 1)
        XCTAssert(after.first!.watched!)
    }

    func testAddMovieActionShouldUpdateExistingMovie() {
        // Given
        var movie = Movie(id: 0)
        movie.watched = false
        let before: Set<Movie> = [movie]

        movie.watched = true
        let action = MovieAction.add(movie: movie)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.count, 1)
        XCTAssert(after.first!.watched!)
    }

    func testDeleteMovieActionShouldDeleteExistingMovie() {
        // Given
        let movie = Movie(id: 0)
        let movie2 = Movie(id: 1)
        let before: Set<Movie> = [movie, movie2]

        let action = MovieAction.delete(movie: movie2)

        // When
        let after = movieReducer(action: action, state: before)

        // Then
        XCTAssertEqual(after.count, 1)
        XCTAssert(after.contains(movie))
        XCTAssertFalse(after.contains(movie2))
    }
}
