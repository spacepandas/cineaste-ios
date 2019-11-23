//
//  Int16+Formatter.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.04.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension Int16 {
    var formatted: String? {
        let formatter = NumberFormatter()
        formatter.numberStyle = .none
        return formatter.string(from: NSNumber(value: self))
    }
}
