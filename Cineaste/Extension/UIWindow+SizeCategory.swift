//
//  UIWindow+SizeCategory.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 26.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import UIKit

// Credits for this idea from the great talk at AppBuilders 2019 go to Janina
// Kutyn: "Size Doesn't Matter: Building an App for Every iOS Device",
// See the complete talk here: https://www.youtube.com/watch?v=2sImrtlesfQ

extension UIWindow {

    /// A more precise description of how wide the screen is.
    ///
    /// This is sometimes more useful than working with the built in size classes,
    /// as iPad has a `regular` size class for portrait and landscape.
    var sizeCategory: SizeCategory {
        switch bounds.width {
        case 0...320:
            // up to iPhone SE
            return .extraSmall
        case 321...414:
            // up to iPhone Xs Max
            return .small
        case 415...1_366:
            // up to iPad Pro 12.9"
            return .medium
        default:
            return .large
        }
    }
}
