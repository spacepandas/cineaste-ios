//
//  Appearance.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 26.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

enum Appearance {
    static func setup() {
        // MARK: TabBar
        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.tintColor = .cineTabBarSelected
        tabBar.barTintColor = .cineTabBar
        tabBar.unselectedItemTintColor = .cineTabBarNormal

        // MARK: TabBarItem
        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes([
            .foregroundColor: UIColor.cineTabBarSelected
            ], for: .selected)
        tabBarItem.setTitleTextAttributes([
            .foregroundColor: UIColor.cineTabBarNormal
            ], for: .normal)

        // MARK: UIAlertController
        let alertController = UIView
            .appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertController.tintColor = .cineAlertTint

        // MARK: UIToolBar
        let toolBar = UIToolbar.appearance()
        toolBar.tintColor = .cineToolBarTint
    }
}
