//
//  NavigationViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 09.04.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class OrangeNavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .basicWhite

        navigationItem.largeTitleDisplayMode = .automatic
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .primaryOrange
        navigationBar.tintColor = .basicWhite

        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.basicWhite
        ]
        let largeTitleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.basicWhite
        ]

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithDefaultBackground()
            navBarAppearance.backgroundColor = .primaryOrange

            navBarAppearance.titleTextAttributes = titleTextAttributes
            navBarAppearance.largeTitleTextAttributes = largeTitleTextAttributes

            navigationBar.standardAppearance = navBarAppearance
            navigationBar.compactAppearance = navBarAppearance
            navigationBar.scrollEdgeAppearance = navBarAppearance
        } else {
            navigationBar.titleTextAttributes = titleTextAttributes
            navigationBar.largeTitleTextAttributes = largeTitleTextAttributes
        }
    }

    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

}
