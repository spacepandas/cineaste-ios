//
//  Dependencies.swift
//  Cineaste
//
//  Created by Christian Braun on 14.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

struct Dependencies {
    static let shared = Dependencies()

    let gnsMessageManager: GNSMessageManager

    private init() {
        gnsMessageManager = GNSMessageManager(apiKey: ApiKeyStore.nearbyKey())
        #if DEBUG
//            GNSMessageManager.setDebugLoggingEnabled(true)
        #endif
    }
}
