//
//  NearbyMessage.swift
//  Cineaste
//
//  Created by Christian Braun on 20.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

struct NearbyMessage: Codable, Equatable, Hashable {

    let userName: String
    let deviceId: String
    let movies: [NearbyMovie]

    static func create(withUsername username: String, movies: [NearbyMovie]) -> NearbyMessage {
        guard let deviceId = UIDevice.current.identifierForVendor?.description else {
            fatalError("Unable to get UUID")
        }
        return NearbyMessage(userName: username,
                             deviceId: deviceId,
                             movies: movies)
    }

    static func == (lhs: NearbyMessage, rhs: NearbyMessage) -> Bool {
        return lhs.deviceId == rhs.deviceId
    }

    var hashValue: Int {
       return userName.hashValue ^ deviceId.hashValue
    }
}
