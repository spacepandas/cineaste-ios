//
//  SettingsCellTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SettingsCellTests: XCTestCase {
    let cell = SettingsCell()

    override func setUp() {
        super.setUp()

        let title = TitleLabel()
        cell.addSubview(title)
        cell.title = title
    }

    func testCellIdentifierForSettingsCell() {
        XCTAssertEqual(SettingsCell.identifier, "SettingsCell")
    }

    func testConfigureShouldSetCellTitleCorrectly() {
        cell.configure(with: settingsItem)

        XCTAssertEqual(cell.title.text, settingsItem.title)
    }

    private let settingsItem: SettingItem = {
        return SettingItem.about
    }()
}
