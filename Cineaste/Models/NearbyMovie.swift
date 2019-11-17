//
//  NearbyMovie.swift
//  Cineaste
//
//  Created by Christian Braun on 20.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

struct NearbyMovie: Codable, Hashable {
    let id: Int64
    let title: String
    let posterPath: String?
}
