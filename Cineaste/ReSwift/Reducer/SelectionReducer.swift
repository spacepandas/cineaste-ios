//
//  SelectionReducer.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

func selectionReducer(action: Action, state: SelectedMovieState?) -> SelectedMovieState {
    var state = state ?? SelectedMovieState()

    guard let action = action as? SelectionAction else { return state }

    switch action {
    case .select(let movie):
        state.movie = movie
    }

    return state
}
