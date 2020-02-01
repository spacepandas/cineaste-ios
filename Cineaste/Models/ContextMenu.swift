//
//  PreviewAction.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 13.10.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

enum ContextMenu {
    case share(Movie, viewController: UIViewController)
    case delete(Movie)
    case moveToWatchlist(Movie)
    case moveToSeen(Movie)

    @available(iOS 13.0, *)
    var action: UIAction {
        switch self {
        case .share(let movie, let presenter):
            return UIAction(
                title: "Share",
                image: UIImage(systemName: "square.and.arrow.up"),
                identifier: UIAction.Identifier(rawValue: "share")
            ) { _ in
                presenter.share(movie: movie)
            }
        case .delete(let movie):
            return UIAction(
                title: String.deleteActionLong,
                image: UIImage(systemName: "trash"),
                identifier: UIAction.Identifier(rawValue: "delete"),
                attributes: .destructive
            ) { _ in
                store.dispatch(deleteMovie(movie))
            }
        case .moveToWatchlist(let movie):
            return UIAction(
                title: String.watchlistActionLong,
                image: UIImage(systemName: "star"),
                identifier: UIAction.Identifier(rawValue: "watchlist")
            ) { _ in
                store.dispatch(markMovie(movie, watched: false))
            }
        case .moveToSeen(let movie):
            return UIAction(
                title: String.seenActionLong,
                image: UIImage(systemName: "checkmark"),
                identifier: UIAction.Identifier(rawValue: "seen")
            ) { _ in
                store.dispatch(markMovie(movie, watched: true))
            }
        }
    }

    @available(iOS 13.0, *)
    static func actions(for movie: Movie, presenter: UIViewController? = nil) -> [UIAction] {
        var actions: [UIAction] = []

        if let presenter = presenter {
            actions.append(ContextMenu.share(movie, viewController: presenter).action)
        }

        switch movie.currentWatchState {
        case .undefined:
            let moreActions = [
                ContextMenu.moveToWatchlist(movie).action,
                ContextMenu.moveToSeen(movie).action
            ]
            actions.append(contentsOf: moreActions)
        case .seen:
            let moreActions = [
                ContextMenu.moveToWatchlist(movie).action,
                ContextMenu.delete(movie).action
            ]
            actions.append(contentsOf: moreActions)
        case .watchlist:
            let moreActions = [
                ContextMenu.moveToSeen(movie).action,
                ContextMenu.delete(movie).action
            ]
            actions.append(contentsOf: moreActions)
        }

        return actions
    }

}
