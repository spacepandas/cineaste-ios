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
        settingsDetailVC.contentType = .imprint
        XCTAssertEqual(settingsDetailVC.settingsDetailTextView.text, TextViewContent.imprint.content)

        settingsDetailVC.contentType = .licence
        XCTAssertEqual(settingsDetailVC.settingsDetailTextView.text, TextViewContent.licence.content)
    }
}
