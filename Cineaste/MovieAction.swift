//
//  MovieAction.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

enum MovieAction: Action {
    case add(movie: Movie)
    case update(movie: Movie)
    case delete(movie: Movie)
}

enum SelectionAction: Action {
    case select(movie: Movie)
}
