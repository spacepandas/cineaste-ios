//
//  SearchMoviesViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 23.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class SearchMoviesViewControllerTests: XCTestCase {

    func testMoviesWithWatchStatesShouldBeConfiguredCorrectlyForWatchlist() {
        // Given
        let viewController = SearchMoviesViewController.instantiate()
        let movieToTest = Movie.testingWatchlist

        let storedIds = StoredMovieIDs(
            watchListMovieIDs: [movieToTest.id],
            seenMovieIDs: []
        )

        var networkingMovie = movieToTest
        networkingMovie.watched = false
        networkingMovie.watchedDate = nil
        let networkingMovies: Set<Movie> = [networkingMovie]

        let expectedMovies = [networkingMovie]

        // When
        let moviesWithWatchStates = viewController.updateMoviesWithWatchState(
            with: storedIds,
            moviesFromNetworking: networkingMovies
        )

        // Then
        XCTAssertEqual(moviesWithWatchStates, expectedMovies)
    }

    func testMoviesWithWatchStatesShouldBeConfiguredCorrectlyForUndefined() {
        // Given
        let viewController = SearchMoviesViewController.instantiate()
        let movieToTest = Movie.testingWatchlist

        let storedIds = StoredMovieIDs(
            watchListMovieIDs: [],
            seenMovieIDs: []
        )

        var networkingMovie = movieToTest
        networkingMovie.watched = nil
        networkingMovie.watchedDate = nil
        let networkingMovies: Set<Movie> = [networkingMovie]

        let expectedMovies = [networkingMovie]

        // When
        let moviesWithWatchStates = viewController.updateMoviesWithWatchState(
            with: storedIds,
            moviesFromNetworking: networkingMovies
        )

        // Then
        XCTAssertEqual(moviesWithWatchStates, expectedMovies)
    }

    func testMoviesWithWatchStatesShouldBeConfiguredCorrectlyForSeen() {
        // Given
        let viewController = SearchMoviesViewController.instantiate()
        let movieToTest = Movie.testingSeen

        let storedIds = StoredMovieIDs(
            watchListMovieIDs: [],
            seenMovieIDs: [movieToTest.id]
        )

        var networkingMovie = movieToTest
        networkingMovie.watched = true
        networkingMovie.watchedDate = Date(timeIntervalSince1970: 4)
        let networkingMovies: Set<Movie> = [networkingMovie]

        let expectedMovies = [networkingMovie]

        // When
        let moviesWithWatchStates = viewController.updateMoviesWithWatchState(
            with: storedIds,
            moviesFromNetworking: networkingMovies
        )

        // Then
        XCTAssertEqual(moviesWithWatchStates, expectedMovies)
    }

}
