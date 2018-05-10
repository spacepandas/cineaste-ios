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
        DateFormatter()
    }()

    var formatted: String {
        Date.dateFormatter.locale = Locale.current
        Date.dateFormatter.dateStyle = .medium
        return Date.dateFormatter.string(from: self)
    }

    var formattedForRequest: String {
        Date.dateFormatter.dateFormat = "yyyy-MM-dd"
        return Date.dateFormatter.string(from: self)
    }

    var formattedForJson: String {
        //important to have locale as "en_US_POSIX" for export and import
        Date.dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        Date.dateFormatter.dateFormat = "MMM dd, yyyy HH:mm:ss"
        return Date.dateFormatter.string(from: self)
    }
}
