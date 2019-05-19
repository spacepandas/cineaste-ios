//
//  AppState.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

struct AppState: StateType, Equatable {
    var movies: Set<Movie> = []
    var selectedMovieId: Int64?
}