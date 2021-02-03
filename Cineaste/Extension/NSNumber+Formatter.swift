//
//  NSNumber+Formatter.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 03.02.21.
//  Copyright © 2021 spacepandas.de. All rights reserved.
//

import Foundation

extension NSNumber {

    /// A formatted String to represent a percentage, e.g. "25%"
    var formattedForPercentage: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .percent
        return formatter.string(from: self)
    }
}
