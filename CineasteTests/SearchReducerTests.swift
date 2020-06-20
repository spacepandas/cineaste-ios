//
//  SearchReducerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 20.06.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

//TODO: add more tests for SearchReducer
class SearchReducerTests: XCTestCase {

    func testUpdateSearchQueryActionShouldUpdateSearchQuery() {
        // Given
        let query = "First Man"
        let action = SearchAction.updateSearchQuery(query: query)
        let expectedState = SearchState(
            searchQuery: query
        )

        // When
        let state = searchReducer(action: action, state: SearchState())

        // Then
        XCTAssertEqual(state, expectedState)
    }

    func testSelectGenreActionShouldAppendGenreAndResetQuery() {
        // Given
        let genre = Genre(id: 0, name: "Horror")
        let action = SearchAction.selectGenre(genre: genre)
        let expectedState = SearchState(
            selectedGenres: [genre]
        )

        // When
        let state = searchReducer(action: action, state: SearchState(searchQuery: "Hor"))

        // Then
        XCTAssertEqual(state, expectedState)
    }

    func testDeselectGenreActionShouldRemoveGenre() {
        // Given
        let genre = Genre(id: 0, name: "Horror")
        let action = SearchAction.deselectGenre(genre: genre)
        let expectedState = SearchState()

        // When
        let state = searchReducer(
            action: action,
            state: SearchState(selectedGenres: [genre])
        )

        // Then
        XCTAssertEqual(state, expectedState)
    }

    func testResetSearchActionShouldResetSearch() {
        // Given
        let genre = Genre(id: 0, name: "Horror")
        let query = "First Man"
        let action = SearchAction.resetSearch
        let expectedState = SearchState()

        // When
        let state = searchReducer(
            action: action,
            state: SearchState(
                selectedGenres: [genre],
                searchQuery: query,
                searchResult: []
            )
        )

        // Then
        XCTAssertEqual(state, expectedState)
    }

}
