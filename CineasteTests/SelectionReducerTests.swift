//
//  SelectionReducerTests.swift
//  CineasteTests
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class SelectionReducerTests: XCTestCase {

    func testSelectMovieActionShouldSelectMovie() {
        // Given
        let movie = Movie.testingSeen
        let action = SelectionAction.select(movie: movie)

        // When
        let after = selectionReducer(action: action, state: SelectedMovieState())

        // Then
        XCTAssertEqual(after.movie, movie)
    }
}
