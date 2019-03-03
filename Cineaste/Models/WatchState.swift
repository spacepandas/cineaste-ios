//
//  WatchState.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 03.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

enum WatchState {
    case undefined
    case seen
    case watchlist

    var actionBackgroundColor: UIColor? {
        switch self {
        case .undefined:
            return nil
        case .watchlist:
            return .basicYellow
        case .seen:
            return .primaryOrange
        }
    }

    var actionImage: UIImage? {
        switch self {
        case .undefined:
            return nil
        case .watchlist:
            return .watchlistIcon
        case .seen:
            return .seenIcon
        }
    }

    var actionTitle: String {
        switch self {
        case .undefined:
            return .deleteMovie
        case .watchlist:
            return .watchlistAction
        case .seen:
            return .seenAction
        }
    }
}
