//
//  NearbyReducer.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 24.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import ReSwift

func nearbyReducer(action: Action, state: NearbyState?) -> NearbyState {
    var state = state ?? NearbyState()

    guard let action = action as? NearbyAction else { return state }

    switch action {
    case .select(let nearbyMessages):
        state.selectedNearbyMessages = nearbyMessages
    case .setNearbyMessages(let nearbyMessages):
        state.nearbyMessages = nearbyMessages
    case .addNearbyMessage(let nearbyMessage):
        if !state.nearbyMessages.contains(nearbyMessage) {
            state.nearbyMessages.append(nearbyMessage)
        }
    case .deleteNearbyMessage(let nearbyMessage):
        state.nearbyMessages = state.nearbyMessages
            .filter { $0 != nearbyMessage }
    }

    return state
}
