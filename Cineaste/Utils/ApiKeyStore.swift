//
//  ApiKeyStore.swift
//  Cineaste
//
//  Created by Christian Braun on 20.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

enum ApiKeyStore {
    static let theMovieDbKey = getValue(forKey: "MOVIEDB_KEY")

    #if DEBUG && targetEnvironment(simulator)

    /// When using the simulator, the API key from Google Nearby
    /// results in crashing the application. Only in DEBUG mode,
    /// we can use an empy String to simulate the feature.
    static let nearbyKey = ""

    #else
    static let nearbyKey = getValue(forKey: "NEARBY_KEY")
    #endif

    private static func getValue(forKey key: String) -> String {
        guard let data = NSDataAsset(name: "ApiKeys", bundle: Bundle.main)?.data,
            let plist = try? PropertyListSerialization
                .propertyList(from: data, options: [], format: nil) as? NSDictionary
            else { fatalError("ApiKeys data set with plist not found") }

        guard let value = plist?.object(forKey: key) as? String
            else { fatalError("Can't find value for apikey: \(key)") }

        return value
    }
}
