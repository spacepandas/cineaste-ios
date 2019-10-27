//
//  CustomSafariViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 12.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import SafariServices

class CustomSafariViewController: SFSafariViewController {
    init(url: URL) {
        super.init(url: url, configuration: .init())

        preferredBarTintColor = .basicBlack
        preferredControlTintColor = .white
    }
}
