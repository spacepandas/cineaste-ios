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

    private static func getValue(forKey key: String) -> String {
        guard let data = NSDataAsset(name: "ApiKeys")?.data,
            let plist = try? PropertyListSerialization
                .propertyList(from: data, options: [], format: nil) as? NSDictionary
            else { fatalError("ApiKeys data set with plist not found") }

        guard let value = plist.object(forKey: key) as? String
            else { fatalError("Can't find value for apikey: \(key)") }

        return value
    }
}
