//
//  Movie+DifferenceReleaseDate.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 04.10.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Foundation

extension Movie {
    var difference: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .weekOfMonth]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.collapsesLargestUnit = true
        let formattedReleaseDate = formatter.string(
            from: Current.date(),
            to: (releaseDate ?? Current.date()) + 24 * 60 * 60
        ) ?? ""

        return formattedReleaseDate
    }
}
