//
//  Decimal+Formatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.04.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension Decimal {
    private static let numberFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.minimumFractionDigits = 1
        formatter.maximumFractionDigits = 1
        return formatter
    }()

    var formattedWithOneFractionDigit: String? {
        return Decimal.numberFormatter.string(from: self as NSDecimalNumber)
    }
}
