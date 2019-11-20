//
//  AppReducer.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    return AppState(
        movies: movieReducer(action: action, state: state?.movies),
        selectedMovieId: selectionReducer(action: action, state: state?.selectedMovieId)
    )
}
