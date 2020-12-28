//
//  DateFormatter+Cineaste.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 24.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import Foundation

extension DateFormatter {
    /// A DateFormatter to format dates in format `yyyy-MM-dd` and in UTC time zone
    static let utcFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        return formatter
    }()

    /// A DateFormatter to format dates in format of import and export movies
    static let importFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        return formatter
    }()
}
