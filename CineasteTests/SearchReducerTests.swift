//
//  SearchReducerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 20.06.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class SearchReducerTests: XCTestCase {

    func testUpdateSearchQueryActionShouldUpdateSearchQuery() {
        // Given
        let query = "First Man"
        let action = SearchAction.updateSearchQuery(query: query)
        let state = SearchState(
            currentPage: 3,
            searchResult: [Movie.testing],
            totalResults: 10,
            currentRequest: nil
        )
        let expectedState = SearchState(
            searchQuery: query
        )

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testSelectGenreActionShouldAppendGenreAndResetQuery() {
        // Given
        let genre = Genre(id: 0, name: "Horror")
        let action = SearchAction.selectGenre(genre: genre)
        let state = SearchState(
            searchQuery: "Hor",
            currentPage: 3,
            searchResult: [Movie.testing],
            totalResults: 10,
            currentRequest: nil
        )
        let expectedState = SearchState(
            selectedGenres: [genre]
        )

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testDeselectGenreActionShouldRemoveGenre() {
        // Given
        let genre = Genre(id: 0, name: "Horror")
        let action = SearchAction.deselectGenre(genre: genre)
        let state = SearchState(
            selectedGenres: [genre],
            currentPage: 3,
            searchResult: [Movie.testing],
            totalResults: 10,
            currentRequest: nil
        )
        let expectedState = SearchState()

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testShowNextPageActionShouldUpdateCurrentPageWhenNotLoadedAllMovies() {
        // Given
        let action = SearchAction.showNextPage
        let state = SearchState(
            currentPage: 1,
            initialSearchResult: [Movie.testingWatchlist2],
            searchResult: [Movie.testing],
            totalResults: 10
        )
        var expectedState = state
        expectedState.currentPage = 2

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testShowNextPageActionShouldNotUpdateCurrentPageWhenLoadedAllMovies() {
        // Given
        let action = SearchAction.showNextPage
        let state = SearchState(
            currentPage: 1,
            initialSearchResult: [Movie.testingWatchlist2],
            searchResult: [Movie.testing],
            totalResults: 1
        )
        let expectedState = state

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testUpdateSearchResultsShouldAppendSearchResults() {
        // Given
        let action = SearchAction.updateSearchResult(result: [Movie.testingWatchlist2])
        let state = SearchState(
            searchResult: [Movie.testing]
        )
        let expectedState = SearchState(
            searchResult: [
                Movie.testing,
                Movie.testingWatchlist2
            ]
        )

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testUpdateTotalResultsShouldUpdateTotalResults() {
        // Given
        let total = 3
        let action = SearchAction.updateTotalResults(total)
        let state = SearchState(
            totalResults: 5
        )
        let expectedState = SearchState(
            totalResults: total
        )

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testUpdateNetworkRequestShouldUpdateNetworkRequest() {
        // Given
        let task = URLSessionTask()
        let action = SearchAction.updateNetworkRequest(task)
        let expectedState = SearchState(
            currentRequest: task
        )

        // When
        let state = searchReducer(action: action, state: SearchState())

        // Then
        XCTAssertEqual(state, expectedState)
    }

    func testSetInitialSearchResultShouldAppendSearchResults() {
        // Given
        let action = SearchAction.setInitialSearchResult(result: [Movie.testingWatchlist2])
        let state = SearchState(
            initialSearchResult: [Movie.testing]
        )
        let expectedState = SearchState(
            initialSearchResult: [
                Movie.testing,
                Movie.testingWatchlist2
            ]
        )

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

    func testResetSearchActionShouldResetSearch() {
        // Given
        let action = SearchAction.resetSearch
        let state = SearchState(
            selectedGenres: [Genre(id: 0, name: "Horror")],
            searchQuery: "First Man",
            currentPage: 3,
            initialSearchResult: [Movie.testingWatchlist2],
            searchResult: [Movie.testing],
            totalResults: 10,
            currentRequest: nil
        )
        let expectedState = SearchState(initialSearchResult: [Movie.testingWatchlist2])

        // When
        let newState = searchReducer(action: action, state: state)

        // Then
        XCTAssertEqual(newState, expectedState)
    }

}
