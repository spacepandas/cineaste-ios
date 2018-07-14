//
//  ApiKeyStore.swift
//  Cineaste
//
//  Created by Christian Braun on 20.10.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

enum ApiKeyStore {
    static func theMovieDbKey() -> String {
        return getValue(forKey: "MOVIEDB_KEY")
    }

    static func nearbyKey() -> String {
        return getValue(forKey: "NEARBY_KEY")
    }

    private static func getValue(forKey key: String) -> String {
        guard let path = Bundle.main.path(forResource: "apikey", ofType: "plist")
            else {
                fatalError("No apikey file")
        }

        let plist = NSDictionary(contentsOfFile: path)
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Can't find value for apikey: \(key)")
        }
        return value
    }
}
