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

        let new3 = #colorLiteral(red: 0.9882352941, green: 0.7921568627, blue: 0.2745098039, alpha: 1)

        let whiteTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.basicWhite
        ]
        let yellowTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.basicYellow
        ]
        let darkTextAttributes = [
            NSAttributedStringKey.foregroundColor: UIColor.basicBackground
        ]

        let navigationBar = UINavigationBar.appearance()
        navigationBar.tintColor = .primaryOrange

        if #available(iOS 11.0, *) {
            navigationBar.largeTitleTextAttributes = whiteTextAttributes
        }

        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.tintColor = .basicYellow
        tabBar.barTintColor = .primaryOrange
        tabBar.unselectedItemTintColor = .basicWhite

        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(yellowTextAttributes, for: .selected)
        tabBarItem.setTitleTextAttributes(darkTextAttributes, for: .normal)

        let searchBar = UISearchBar.appearance()
        searchBar.tintColor = .basicWhite
        searchBar.barTintColor = .primaryOrange

        //change color of cursor
        let searchField = UITextField.appearance(whenContainedInInstancesOf: [UISearchBar.self])
        searchField.tintColor = .basicBackground
    }
}
