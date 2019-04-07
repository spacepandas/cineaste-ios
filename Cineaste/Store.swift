//
//  Store.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.04.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

let store = Store<AppState>(
    reducer: movieReducer,
    state: nil
)
