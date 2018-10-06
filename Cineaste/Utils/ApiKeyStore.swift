//
//  ApiKeyStore.swift
//  Cineaste
//
//  Created by Christian Braun on 20.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

enum ApiKeyStore {
    static let theMovieDbKey = getValue(forKey: "MOVIEDB_KEY")

    #if DEBUG

    /// When using the simulator, the API key from Google Nearby
    /// results in crashing the application. Only in DEBUG mode,
    /// we can use an empy String to simulate the feature.
    static let nearbyKey = ""

    #else
    static let nearbyKey = getValue(forKey: "NEARBY_KEY")
    #endif

    private static func getValue(forKey key: String) -> String {
        guard let path = Bundle.main.path(forResource: "apikey", ofType: "plist")
            else { fatalError("No apikey file") }

        let plist = NSDictionary(contentsOfFile: path)
        guard let value = plist?.object(forKey: key) as? String
            else { fatalError("Can't find value for apikey: \(key)") }

        return value
    }
}
