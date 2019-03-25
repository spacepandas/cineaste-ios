//
//  SettingsCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class SettingsCellTests: XCTestCase {
    let cell = SettingsCell()

    override func setUp() {
        super.setUp()

        let title = UILabel()
        cell.addSubview(title)
        cell.title = title

        let description = UILabel()
        cell.addSubview(description)
        cell.descriptionLabel = description
    }

    func testConfigureShouldSetCellTitleCorrectly() {
        let aboutItem = SettingItem.about
        cell.configure(with: aboutItem)

        XCTAssertEqual(cell.title.text, aboutItem.title)
        XCTAssert(cell.descriptionLabel.isHidden)

        let importItem = SettingItem.importMovies
        cell.configure(with: importItem)
        XCTAssertEqual(cell.title.text, importItem.title)
        XCTAssertFalse(cell.descriptionLabel.isHidden)
        XCTAssertEqual(cell.descriptionLabel.text, importItem.description)
    }
}
