//
//  SettingsViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App

class SettingsViewControllerTests: XCTestCase {
    let settingsVC = SettingsViewController.instantiate()

    func testSelectRowShouldSetCorrectSelectedSetting() {
        // nothing selected
        XCTAssertNil(settingsVC.selectedSetting)

        // select first row
        let firstPath = IndexPath(row: 0, section: 0)
        settingsVC.tableView.delegate?.tableView!(settingsVC.tableView, didSelectRowAt: firstPath)
        XCTAssert(settingsVC.selectedSetting == settingsVC.settings[firstPath.row])

        // select second row
        let secondPath = IndexPath(row: 1, section: 0)
        settingsVC.tableView.delegate?.tableView!(settingsVC.tableView, didSelectRowAt: secondPath)
        XCTAssert(settingsVC.selectedSetting == settingsVC.settings[secondPath.row])
    }

    func testCellForRowShouldBeOfTypeSettingsCell() {
        for row in 0..<settingsVC.settings.count {
            let path = IndexPath(row: row, section: 0)
            let cell = settingsVC.tableView.dataSource?
                .tableView(settingsVC.tableView, cellForRowAt: path)

            XCTAssert(cell is SettingsCell)
        }
    }

    func testDequeueReusableCellWithSettingsCellIdentifierShouldReturnTableViewCell() {
        let tableView = settingsVC.tableView!

        // important:
        // use dequeueReusableCell:withIdentifier for this test, this method
        // returns nil, when the tableView can not dequeue a reusable cell,
        // with dequeueReusableCell:withIdentifier:indexPath it would simply
        // crash at this point
        let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier)
        XCTAssertNotNil(cell)

        let invalidCell = tableView.dequeueReusableCell(withIdentifier: "invalidIdentifier")
        XCTAssertNil(invalidCell)
    }
}
