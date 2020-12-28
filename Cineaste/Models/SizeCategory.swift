//
//  SizeCategory.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 26.12.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import UIKit

/// A more precise description of how wide the screen is. You can define the
/// size category for a screen with the extension for `UIWindow`, e.g. `UIApplication.shared.keyWindow?.sizeCategory`.
///
/// This is sometimes more useful than working with the built in size classes,
/// as iPad has a `regular` size class for portrait and landscape.
enum SizeCategory {
    case extraSmall
    case small
    case medium
    case large

    var relativePosterSize: CGFloat {
        switch self {
        case .extraSmall,
             .small:
            return 0.22
        case .medium,
             .large:
            return 0.15
        }
    }

    var relativeWatchStateImageSize: CGFloat {
        switch self {
        case .extraSmall,
             .small:
            return 0.15
        case .medium,
             .large:
            return 0.09
        }
    }
}
