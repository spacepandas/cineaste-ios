//
//  SearchAction.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 20.06.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import ReSwift

enum SearchAction: Action {
    case updateSearchQuery(query: String)
    case selectGenre(genre: Genre)
    case deselectGenre(genre: Genre)
    case resetSearch
}
