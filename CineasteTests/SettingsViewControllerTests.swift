//
//  SettingsViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SettingsViewControllerTests: XCTestCase {
    let settingsVC = SettingsViewController.instantiate()

    override func setUp() {
        super.setUp()

        settingsVC.settings = []
    }

    func testNumberOfSectionsShouldEqualOne() {
        XCTAssertEqual(settingsVC.settingsTableView.numberOfSections, 1)
    }

    func testNumberOfRowsShouldEqualNumberOfSettingItems() {
        XCTAssertEqual(settingsVC.settingsTableView.numberOfRows(inSection: 0), 0)

        settingsVC.settings = settingsItems

        XCTAssertEqual(settingsVC.settingsTableView.numberOfRows(inSection: 0), 2)
    }

    func testCellWithSegueShouldHaveDisclosureIndicator() {
        settingsVC.settings = settingsItems

        for row in 0..<settingsItems.count {
            let path = IndexPath(row: row, section: 0)
            let cell = settingsVC.settingsTableView.cellForRow(at: path)

            if settingsItems[row].segue == nil {
                XCTAssert(cell?.accessoryType == .none)
            } else {
                XCTAssert(cell?.accessoryType == .disclosureIndicator)
            }
        }
    }

    func testPrepareForSegueShouldInjectCorrectContentToImprintVC() {
        let targetViewController = SettingsDetailViewController.instantiate()
        let targetSegue = UIStoryboardSegue(
            identifier: Segue.showTextViewFromSettings.rawValue,
            source: settingsVC,
            destination: targetViewController)

        //inject imprint data
        let imprintItem = settingsItems[0]
        settingsVC.selectedSetting = imprintItem
        settingsVC.prepare(for: targetSegue, sender: settingsVC)

        XCTAssertEqual(targetViewController.title, imprintItem.title)
        XCTAssertEqual(targetViewController.textViewContent, .imprint)

        //inject licence data
        let licenceItem = settingsItems[1]
        settingsVC.selectedSetting = licenceItem
        settingsVC.prepare(for: targetSegue, sender: settingsVC)

        XCTAssertEqual(targetViewController.title, licenceItem.title)
        XCTAssertEqual(targetViewController.textViewContent, .licence)
    }

    func testSelectRowShouldSetCorrectSelectedSetting() {
        settingsVC.settings = settingsItems
        //nothing selected
        XCTAssertNil(settingsVC.selectedSetting)

        //select first row
        let firstPath = IndexPath(row: 0, section: 0)
        settingsVC.settingsTableView.delegate?.tableView!(settingsVC.settingsTableView, didSelectRowAt: firstPath)
        XCTAssert(settingsVC.selectedSetting == settingsItems[firstPath.row])

        //select second row
        let secondPath = IndexPath(row: 1, section: 0)
        settingsVC.settingsTableView.delegate?.tableView!(settingsVC.settingsTableView, didSelectRowAt: secondPath)
        XCTAssert(settingsVC.selectedSetting == settingsItems[secondPath.row])
    }

    func testCellForRowShouldBeOfTypeSettingsCell() {
        settingsVC.settings = settingsItems

        for row in 0..<settingsItems.count {
            let path = IndexPath(row: row, section: 0)
            let cell = settingsVC.settingsTableView.cellForRow(at: path)

            XCTAssert(cell is SettingsCell)
        }
    }

    func testDequeueReusableCellWithSettingsCellIdentifierShouldReturnTableViewCell() {
        let tableView = settingsVC.settingsTableView!

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

    private let settingsItems: [SettingItem] = {
        return [SettingItem.about,
                SettingItem.licence]
    }()
}
