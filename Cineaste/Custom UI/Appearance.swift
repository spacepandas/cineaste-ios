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
        // MARK: UIAlertController
        let alertController = UIView
            .appearance(whenContainedInInstancesOf: [UIAlertController.self])
        alertController.tintColor = .cineAlertTint

        // MARK: UIToolBar
        let toolBar = UIToolbar.appearance()
        toolBar.tintColor = .cineToolBarTint

        // MARK: SegmentedControl
        let segmentedControl = UISegmentedControl.appearance()
        if #available(iOS 13.0, *) {
            // due to issues with dynamic type and styled segmented controls,
            // don't style the segmented control for iOS 13 at all (#117)
        } else {
            segmentedControl.tintColor = UIColor.cineSegmentedControlTint
        }
    }
}
