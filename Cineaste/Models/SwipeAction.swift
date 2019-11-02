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

    func contextualAction(for movie: Movie) -> UIContextualAction {
        let action = UIContextualAction(
            style: .normal,
            title: title) { _, _, success in
                var movie = movie

                switch self {
                case .delete:
                    store.dispatch(MovieAction.delete(movie: movie))
                case .moveToWatchlist:
                    movie.watched = false
                    store.dispatch(MovieAction.update(movie: movie))
                case .moveToSeen:
                    movie.watched = true
                    movie.watchedDate = Date()
                    store.dispatch(MovieAction.update(movie: movie))
                }

                AppStoreReview.requestReview()

                success(true)
        }
        action.backgroundColor = backgroundColor
        action.image = image
        return action
    }

    var backgroundColor: UIColor? {
        switch self {
        case .delete:
            return .cineSwipeDelete
        case .moveToWatchlist:
            return .cineSwipeWatchlist
        case .moveToSeen:
            return .cineSwipeSeen
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
