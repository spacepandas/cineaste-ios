//
//  NavigationViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 09.04.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class NavigationController: UINavigationController {

    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        navigationItem.largeTitleDisplayMode = .automatic
        navigationBar.prefersLargeTitles = true
        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .cineNavBar
        navigationBar.tintColor = .cineNavBarTint

        let titleTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.cineNavBarTitle
        ]
        let largeTitleTextAttributes:[NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.cineNavBarTitle
        ]

        if #available(iOS 13.0, *) {
            let navBarAppearance = UINavigationBarAppearance()
            navBarAppearance.configureWithDefaultBackground()
            navBarAppearance.backgroundColor = .cineNavBar

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
        .lightContent
    }

}
