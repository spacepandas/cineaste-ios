//
//  NearbyMessage.swift
//  Cineaste
//
//  Created by Christian Braun on 20.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

struct NearbyMessage: Codable {
    let userName: String
    let deviceId: String
    let movies: [NearbyMovie]
}
