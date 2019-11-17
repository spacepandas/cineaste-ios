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
        let movie = Movie(id: 0)
        let before: Int64? = 123
        let action = SelectionAction.select(movie: movie)

        // When
        let after = selectionReducer(action: action, state: before)

        // Then
        XCTAssertNotNil(after)
        XCTAssertEqual(after, movie.id)
    }
}
