//
//  EmptyMoviesCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class EmptyMoviesCellTests: XCTestCase {
    let cell = EmptyMoviesCell()

    override func setUp() {
        super.setUp()

        let description = UILabel()
        cell.addSubview(description)
        cell.emptyListDescription = description
    }

    func testDescriptionLabelTextColorIsWhite() {
        cell.emptyListDescription.text = "Test"
        XCTAssertEqual(cell.emptyListDescription.textColor, .basicWhite)
    }

    func testCellIdentifier() {
        XCTAssertEqual(EmptyMoviesCell.identifier, "EmptyMoviesCell")
    }

    func testSettingCategorySetsDescriptionText() {
        cell.category = .wantToSee
        XCTAssertEqual(cell.emptyListDescription.text, "Du hast noch keine Filme auf deiner Watch-List. Füge doch einen neuen Titel hinzu.")
        cell.category = .seen
        XCTAssertEqual(cell.emptyListDescription.text, "Du hast noch keine Filme auf deiner Watched-List. Füge doch einen neuen Titel hinzu.")
    }
}
