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
}

extension NearbyMessage {
    init(with userName: String, movies: [NearbyMovie]) {
        guard let deviceId = UIDevice.current.identifierForVendor?.description
            else { fatalError("Unable to get UUID") }

        self.userName = userName
        self.deviceId = deviceId
        self.movies = movies
    }
}
