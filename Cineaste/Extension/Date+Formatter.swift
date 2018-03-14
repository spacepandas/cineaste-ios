//
//  Date+Formatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

extension Date {
    private static let dateFormatter = { () -> DateFormatter in
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }()

    var formatted: String {
        Date.dateFormatter.dateFormat = "dd.MM.YYYY"
        return Date.dateFormatter.string(from: self)
    }

    var formattedForRequest: String {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        return Date.dateFormatter.string(from: self)
    }

    var formattedForJson: String {
        Date.dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        return Date.dateFormatter.string(from: self)
    }
}
