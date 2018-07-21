//
//  String+Locale.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension String {
    //e.g. "DE"
    static var regionIso31661: String {
        var locale = Locale.current.identifier

        if let dotRange = locale.range(of: "_") {
            locale.removeSubrange(locale.startIndex..<dotRange.upperBound)
        }
        return locale
    }

    //e.g. "de"
    static var languageIso6391: String {
        var locale = Locale.current.identifier
        if let dotRange = locale.range(of: "_") {
            locale.removeSubrange(dotRange.lowerBound..<locale.endIndex)
        }
        return locale
    }

    //e.g. "de-DE
    static var languageFormattedForTMDb: String {
        return Locale.current.identifier.replacingOccurrences(of: "_", with: "-")
    }
}
