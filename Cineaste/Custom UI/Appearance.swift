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
        let whiteTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.basicWhite]
        let darkTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.basicBackground]

        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = .primaryOrange

        if #available(iOS 11.0, *) {
            navigationBar.largeTitleTextAttributes = whiteTextAttributes
        }

        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.tintColor = .basicWhite
        tabBar.barTintColor = .primaryOrange
        tabBar.unselectedItemTintColor = .basicBackground

        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(whiteTextAttributes, for: .selected)
        tabBarItem.setTitleTextAttributes(darkTextAttributes, for: .normal)

        let searchBar = UISearchBar.appearance()
        searchBar.tintColor = .basicWhite
        searchBar.barTintColor = .primaryOrange

        //change color of cursor
        let searchField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchField.tintColor = .basicBackground
    }
}
