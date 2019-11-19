//
//  SettingsDetailViewControllerSnapshotTests.swift
//  CineasteSnapshotTests
//
//  Created by Felizia Bernutz on 01.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import XCTest
import SnapshotTesting
@testable import Cineaste_App

class SettingsDetailViewControllerSnapshotTests: XCTestCase {

    func testGeneralAppearance() {
        // Given
        let viewController = SettingsDetailViewController.instantiate()
        let navigationController = NavigationController(rootViewController: viewController)

        // When
        viewController.configure(with: SettingItem.about.title, textViewContent: .imprint)

        // Then
        assertThemedNavigationSnapshot(matching: navigationController)
    }
}
