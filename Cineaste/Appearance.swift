//
//  Appearance.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 26.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

extension UIColor {
    static let primaryOrange = #colorLiteral(red: 0.9176470588, green: 0.337254902, blue: 0.1882352941, alpha: 1)
    static let primaryDarkOrange = #colorLiteral(red: 0.7294117647, green: 0.2666666667, blue: 0.1490196078, alpha: 1)

    static let basicYellow = #colorLiteral(red: 0.9843137255, green: 0.8862745098, blue: 0.1803921569, alpha: 1)
    static let basicWhite = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
    static let basicBackground = #colorLiteral(red: 0.2549019608, green: 0.2901960784, blue: 0.3176470588, alpha: 1)

    static let accentText = #colorLiteral(red: 0.5098039216, green: 0.5098039216, blue: 0.5019607843, alpha: 1)
}

enum Appearance {
    static func setup() {
        let whiteTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.basicWhite]
        let darkTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.basicBackground]

        let navigationBar = UINavigationBar.appearance()
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .primaryOrange
        navigationBar.tintColor = .basicWhite
        navigationBar.titleTextAttributes = whiteTextAttributes

        let tabBar = UITabBar.appearance()
        tabBar.isTranslucent = false
        tabBar.tintColor = .basicWhite
        tabBar.barTintColor = .primaryOrange

        let tabBarItem = UITabBarItem.appearance()
        tabBarItem.setTitleTextAttributes(whiteTextAttributes, for: .selected)
        tabBarItem.setTitleTextAttributes(darkTextAttributes, for: .normal)
    }
}
