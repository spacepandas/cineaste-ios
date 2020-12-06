//
//  PersistenceSubscriber.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

final class PersistenceSubscriber: StoreSubscriber {
    func newState(state movies: Set<Movie>) {
        try? Persistence.saveMovies(movies)

        SpotlightIndexing.indexItems(movies)
        ShortcutItemRefresher.refreshShortcutItems(for: movies)
    }
}
