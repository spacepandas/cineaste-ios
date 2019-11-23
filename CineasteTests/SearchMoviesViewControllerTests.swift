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
        networkingMovie.watched = nil
        networkingMovie.watchedDate = nil
        let networkingMovies: Set<Movie> = [networkingMovie]

        let expectedMoviesWithWatchStates = [
            networkingMovie: WatchState.watchlist
        ]

        // When
        let moviesWithWatchStates = viewController.updateMoviesWithWatchState(
            with: storedIds,
            moviesFromNetworking: networkingMovies
        )

        // Then
        XCTAssertEqual(moviesWithWatchStates, expectedMoviesWithWatchStates)
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

        let expectedMoviesWithWatchStates = [
            networkingMovie: WatchState.undefined
        ]

        // When
        let moviesWithWatchStates = viewController.updateMoviesWithWatchState(
            with: storedIds,
            moviesFromNetworking: networkingMovies
        )

        // Then
        XCTAssertEqual(moviesWithWatchStates, expectedMoviesWithWatchStates)
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
        networkingMovie.watched = nil
        networkingMovie.watchedDate = nil
        let networkingMovies: Set<Movie> = [networkingMovie]

        let expectedMoviesWithWatchStates = [
            networkingMovie: WatchState.seen
        ]

        // When
        let moviesWithWatchStates = viewController.updateMoviesWithWatchState(
            with: storedIds,
            moviesFromNetworking: networkingMovies
        )

        // Then
        XCTAssertEqual(moviesWithWatchStates, expectedMoviesWithWatchStates)
    }

}
