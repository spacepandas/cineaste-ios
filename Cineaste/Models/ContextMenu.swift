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
    func action(on movie: Movie) -> UIAction {
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
                store.dispatch(MovieAction.delete(movie: movie))
            }
        case .moveToWatchlist:
            return UIAction(
                title: String.watchlistActionLong,
                image: UIImage(systemName: "star"),
                identifier: UIAction.Identifier(rawValue: "watchlist")
            ) { _ in
                var movie = movie
                movie.watched = false

                store.dispatch(MovieAction.update(movie: movie))
            }
        case .moveToSeen:
            return UIAction(
                title: String.seenAction,
                image: UIImage(systemName: "checkmark"),
                identifier: UIAction.Identifier(rawValue: "seen")
            ) { _ in

                var movie = movie
                movie.watched = true
                movie.watchedDate = Date()

                store.dispatch(MovieAction.update(movie: movie))
            }
        }
    }

    @available(iOS 13.0, *)
    static func actions(for movie: Movie) -> [UIAction] {
        if let watched = movie.watched {
            return watched
                ? [ContextMenu.share.action(on: movie),
                   ContextMenu.moveToWatchlist.action(on: movie),
                   ContextMenu.delete.action(on: movie)]
                : [ContextMenu.share.action(on: movie),
                   ContextMenu.moveToSeen.action(on: movie),
                   ContextMenu.delete.action(on: movie)]
        } else {
            return [ContextMenu.share.action(on: movie),
                    ContextMenu.moveToWatchlist.action(on: movie),
                    ContextMenu.moveToSeen.action(on: movie)]
        }
    }

}
