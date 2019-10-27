//
//  PreviewAction.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 13.10.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

enum ContextMenu {
    case share
    case delete
    case moveToWatchlist
    case moveToSeen

    @available(iOS 13.0, *)
    var action: UIAction {
        switch self {
        case .share:
            return UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up"),
                identifier: UIAction.Identifier(rawValue: "share")
            ) { _ in
                //                self.shareMovie()
            }
        case .delete:
            return UIAction(
                title: String.deleteActionLong,
                image: UIImage(systemName: "trash"),
                identifier: UIAction.Identifier(rawValue: "delete"),
                attributes: .destructive
            ) { _ in
                //                self.deleteMovie()
            }
        case .moveToWatchlist:
            return UIAction(
                title: String.watchlistActionLong,
                image: UIImage(systemName: "star"),
                identifier: UIAction.Identifier(rawValue: "watchlist")
            ) { _ in
                //                self.saveMovie(asWatched: false)
            }
        case .moveToSeen:
            return UIAction(
                title: String.seenAction,
                image: UIImage(systemName: "checkmark"),
                identifier: UIAction.Identifier(rawValue: "seen")
            ) { _ in
                //                self.saveMovie(asWatched: true)
            }
        }
    }

    @available(iOS 13.0, *)
    static func actions(for movie: Movie) -> [UIAction] {
        if let watched = movie.watched {
            return watched
                ? [ContextMenu.share.action,
                   ContextMenu.moveToWatchlist.action,
                   ContextMenu.delete.action]
                : [ContextMenu.share.action,
                   ContextMenu.moveToSeen.action,
                   ContextMenu.delete.action]
        } else {
            return [ContextMenu.share.action,
                    ContextMenu.moveToWatchlist.action,
                    ContextMenu.moveToSeen.action]
        }
    }

}
