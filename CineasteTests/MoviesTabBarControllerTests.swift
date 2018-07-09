//
//  MoviesTabBarControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste_App_Dev

class MoviesTabBarControllerTests: XCTestCase {
    let tabBarController = MoviesTabBarController.instantiate()

    func testTabBarViewControllerCount() {
        tabBarController.viewDidLoad()
        XCTAssertEqual(tabBarController.viewControllers?.count, 3)
    }

    func testTabBarViewControllerHierarchy() {
        tabBarController.viewDidLoad()

        for viewController in tabBarController.viewControllers! {
            XCTAssert(viewController is OrangeNavigationController)
        }
    }
    
}
