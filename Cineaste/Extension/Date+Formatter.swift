//
//  Date+Formatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import Foundation

extension Date {

    /// This formatter will produce something like this: "Dec 28, 2020".
    var formatted: String {
        let formatter = DateFormatter()
        formatter.locale = Current.locale
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: self)
    }

    /// This formatter will produce something like this: "2020".
    var formattedOnlyYear: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy"
        return formatter.string(from: self)
    }

    /// This formatter will produce something like this: "December 28, 2020 at 10:49 AM.".
    var formattedWithTime: String {
        let formatter = DateFormatter()
        formatter.timeZone = Current.timeZone
        formatter.locale = Current.locale
        formatter.dateStyle = .long
        formatter.timeStyle = .short
        return formatter.string(from: self)
    }

    /// This formatter will produce something like this: "2020-12-28".
    var formattedForRequest: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.string(from: self)
    }

    /// This formatter will produce something like this: "Dec 28, 2020 10:49:53".
    var formattedForJson: String {
        DateFormatter.importFormatter.string(from: self)
    }
}
