//
//  SettingsDetailViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 19.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SettingsDetailViewControllerTests: XCTestCase {
    let settingsDetailVC = SettingsDetailViewController.instantiate()

    func testTextViewShouldDisplayCorrectContent() {
        settingsDetailVC.textViewContent = .imprint
        XCTAssertEqual(settingsDetailVC.settingsDetailTextView.text, TextViewType.imprint.content)

        settingsDetailVC.textViewContent = .licence
        XCTAssertEqual(settingsDetailVC.settingsDetailTextView.text, TextViewType.licence.content)
    }
}
