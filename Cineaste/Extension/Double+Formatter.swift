//
//  Double+Formatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.04.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension Double {
    var formattedWithOneFractionDigit: String? {
        return String(format: "%.1f", self)
    }
}
