//
//  SettingsViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 01.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class SettingsViewControllerSnapshotTests: XCTestCase {

    override class func setUp() {
        super.setUp()

        UserDefaults.standard.username = "Simulator"
    }

    func testGeneralAppearance() {
        // Given
        let viewController = SettingsViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
