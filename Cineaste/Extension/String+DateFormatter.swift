//
//  String+DateFormatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

extension String {
    public var dateFromImportedMoviesString: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        formatter.timeZone = TimeZone(abbreviation: "UTC")
        formatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        return formatter.date(from: self)
    }

    var dateFromISO8601String: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter.date(from: self)
    }
}
