//
//  PreviewAction.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 14.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

enum PreviewAction {
    case delete
    case moveToWatchlist
    case moveToSeen

    func previewAction(for movie: Movie) -> UIPreviewAction {
        let action = UIPreviewAction(
            title: title,
            style: style) { _, _ -> Void in
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
        }

        return action
    }
}

extension PreviewAction {
    private var style: UIPreviewAction.Style {
        switch self {
        case .delete:
            return .destructive
        case .moveToWatchlist,
             .moveToSeen:
            return .default
        }
    }

    private var title: String {
        switch self {
        case .delete:
            return .deleteActionLong
        case .moveToWatchlist:
            return .watchlistAction
        case .moveToSeen:
            return .seenAction
        }
    }
}
