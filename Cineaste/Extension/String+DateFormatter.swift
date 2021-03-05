//
//  String+DateFormatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

extension String {

    /// Returns a date if the string is valid ISO8601 formatted,
    /// returns nil if the string is not valid
    var dateFromISO8601String: Date? {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [
            .withInternetDateTime,
            .withFractionalSeconds
        ]
        return formatter.date(from: self)
    }
}
