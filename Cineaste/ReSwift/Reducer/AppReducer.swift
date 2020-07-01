//
//  AppReducer.swift
//  Cineaste App
//
//  Created by Xaver Lohmüller on 18.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

func appReducer(action: Action, state: AppState?) -> AppState {
    AppState(
        movies: movieReducer(action: action, state: state?.movies),
        selectedMovieState: selectionReducer(action: action, state: state?.selectedMovieState),
        searchState: searchReducer(action: action, state: state?.searchState)
    )
}
