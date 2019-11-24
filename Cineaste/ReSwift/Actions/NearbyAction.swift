//
//  NearbyAction.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 24.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

enum NearbyAction: Action {
    case select(nearbyMessages: [NearbyMessage])
    case setNearbyMessages([NearbyMessage])
    case addNearbyMessage(NearbyMessage)
    case deleteNearbyMessage(NearbyMessage)
}
