//
//  MyMoviesCategory.swift
//  Cineaste
//
//  Created by Christian Braun on 28.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

enum MovieListCategory: String {
    case watchlist
    case seen

    var title: String {
        switch self {
        case .watchlist:
            return String.watchlist
        case .seen:
            return String.seen
        }
    }

    var image: UIImage {
        switch self {
        case .watchlist:
            return UIImage.watchlistIcon
        case .seen:
            return UIImage.seenIcon
        }
    }

    var action: String {
        switch self {
        case .watchlist:
            return String.watchlistAction
        case .seen:
            return String.seenAction
        }
    }

    var predicate: NSPredicate {
        switch self {
        case .watchlist:
            return NSPredicate(format: "watched == %@", NSNumber(value: false))
        case .seen:
            return NSPredicate(format: "watched == %@", NSNumber(value: true))
        }
    }

    var state: WatchState {
        switch self {
        case .watchlist:
            return .watchlist
        case .seen:
            return .seen
        }
    }
}
