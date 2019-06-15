//
//  SwipeAction.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 09.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

enum SwipeAction {
    case delete
    case moveToWatchlist
    case moveToSeen

    func contextualAction(with completion: @escaping () -> Void) -> UIContextualAction {
        let action = UIContextualAction(
            style: .normal,
            title: title) { _, _, success in
                completion()
                success(true)
        }
        action.backgroundColor = backgroundColor
        action.image = image
        return action
    }

    var backgroundColor: UIColor? {
        switch self {
        case .delete:
            return .superLightGray
        case .moveToWatchlist:
            return .basicYellow
        case .moveToSeen:
            return .primaryOrange
        }
    }
}

private extension SwipeAction {
    var image: UIImage? {
        switch self {
        case .delete:
            return nil
        case .moveToWatchlist:
            return .watchlistIcon
        case .moveToSeen:
            return .seenIcon
        }
    }

    var title: String? {
        switch self {
        case .delete:
            return .deleteMovie
        case .moveToWatchlist:
            return .watchlistAction
        case .moveToSeen:
            return .seenAction
        }
    }
}
