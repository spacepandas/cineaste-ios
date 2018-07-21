//
//  Movie+Formatted.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension Movie {
    var formattedVoteAverage: String {
        if voteCount == 0 {
            return String.unknownVoteAverage
        } else {
            return voteAverage.formattedWithOneFractionDigit
                ?? String.unknownVoteAverage
        }
    }

    var formattedReleaseDate: String {
        if let release = releaseDate {
            return release.formatted
        } else {
            return String.unknownReleaseDate
        }
    }

    var formattedRuntime: String {
        return "\(runtime.formatted ?? String.unknownRuntime) min"
    }
}
