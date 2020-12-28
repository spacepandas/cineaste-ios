//
//  String+VariantFittingPresentationWidth.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.06.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension String {

    /// Returns a smaller variant of the string, depending on the screen width.
    ///
    /// This is especially useful to present a smaller text on small devices in `UITabBarItem`s or in Swipe Actions.
    var forWidth: String {
        let width =
            Int(UIScreen.main.bounds.width) > 320
                ? 35
                : 1
        return (self as NSString).variantFittingPresentationWidth(width)
    }
}
