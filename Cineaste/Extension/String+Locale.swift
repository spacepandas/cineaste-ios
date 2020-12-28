//
//  String+Locale.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension String {
    /// Returns the current region in ISO 3166-1 Format. E.g when current locale is "en_US", it returns "US".
    static var regionIso31661: String {
        if let regionCode = Current.locale.regionCode {
            return regionCode
        }

        var locale = Current.locale.identifier
        locale = locale.replacingOccurrences(of: "-", with: "_")

        if let dotRange = locale.range(of: "_") {
            locale.removeSubrange(locale.startIndex..<dotRange.upperBound)
        }
        return locale
    }

    /// Returns the current language in ISO 6391 Format. E.g when current locale is "en_US", it returns "en".
    static var languageIso6391: String {
        if let languageCode = Current.locale.languageCode {
            return languageCode
        }

        var locale = Current.locale.identifier
        locale = locale.replacingOccurrences(of: "-", with: "_")

        if let dotRange = locale.range(of: "_") {
            locale.removeSubrange(dotRange.lowerBound..<locale.endIndex)
        }
        return locale
    }

    /// Returns the current language in ISO 6391 Format. E.g when current locale is "en_US", it returns "en-US".
    static var languageFormattedForTMDb: String {
        Current.locale.identifier
            .replacingOccurrences(of: "_", with: "-")
    }
}
