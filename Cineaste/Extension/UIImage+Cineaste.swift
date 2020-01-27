//
//  Images.swift
//  Cineaste
//
//  Created by Christian Braun on 13.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension UIImage {
    static let posterPlaceholder = #imageLiteral(resourceName: "placeholder_poster")
    static let seenBadgeIcon = #imageLiteral(resourceName: "seen-badge")
    static let watchlistBadgeIcon = #imageLiteral(resourceName: "watchlist-badge")
    static var watchlistIcon = image(systemName: "star.fill", fallback: #imageLiteral(resourceName: "watchlist"))
    static var seenIcon = image(systemName: "checkmark", fallback: #imageLiteral(resourceName: "seen"))
    static var searchIcon = image(systemName: "magnifyingglass", fallback: #imageLiteral(resourceName: "search"))
    static var moreIcon = image(systemName: "ellipsis", fallback: #imageLiteral(resourceName: "more"))
}

/// Creates an image object containing a system symbol image, if available
/// - Parameters:
///   - systemName: The name of the system symbol image.
///   Only respected in iOS 13 and later.
///   - fallback: Fallback image for iOS 12 and earlier
private func image(systemName: String, fallback: UIImage) -> UIImage {
    if #available(iOS 13, *) {
        // It's better to crash here than have undefined UI
        // swiftlint:disable:next force_unwrapping
        return UIImage(systemName: systemName)!
    } else {
        return fallback
    }
}
