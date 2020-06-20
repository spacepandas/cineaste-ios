//
//  SearchReducer.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 20.06.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import ReSwift

func searchReducer(action: Action, state: SearchState?) -> SearchState {
    var state = state ?? SearchState()

    guard let action = action as? SearchAction else { return state }

    switch action {
    case .updateSearchQuery(let query):
        state.searchQuery = query
    case .selectGenre(let genre):
        state.selectedGenres.append(genre)
    case .deselectGenre(let genre):
        state.selectedGenres = state.selectedGenres.filter { $0 != genre }
    case .resetSearch:
        state = SearchState()
    }

    return state
}
