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
            style: style
        ) { _, _ -> Void in
                switch self {
                case .delete:
                    store.dispatch(deleteMovie(movie))
                case .moveToWatchlist:
                    store.dispatch(markMovie(movie, watched: false))
                case .moveToSeen:
                    store.dispatch(markMovie(movie, watched: true))
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
