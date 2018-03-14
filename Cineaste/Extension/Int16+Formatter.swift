//
//  Int16+Formatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.04.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension Int16 {
    private static let numberFormatter = { () -> NumberFormatter in
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter
    }()

    var formattedForRuntime: String {
        return "\(Int16.numberFormatter.string(from: NSNumber(value: self)) ?? "-.-") min"
    }
}
