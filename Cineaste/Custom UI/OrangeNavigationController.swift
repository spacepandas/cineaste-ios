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

        navigationBar.isTranslucent = false
        navigationBar.barTintColor = .primaryOrange
        navigationBar.tintColor = .basicWhite
        navigationBar.titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor.basicWhite]
        navigationBar.barStyle = .blackOpaque
    }

}
