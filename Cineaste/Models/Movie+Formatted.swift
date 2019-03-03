//
//  Movie+Formatted.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

extension Movie {
    var formattedVoteAverage: String {
        if voteCount != 0 && voteAverage != 0 {
            return voteAverage.formattedWithOneFractionDigit
                ?? String.unknownVoteAverage
        } else {
            return String.unknownVoteAverage
        }
    }

    var formattedReleaseDate: String {
        if let release = releaseDate {
            return release.formatted
        } else {
            return String.unknownReleaseDate
        }
    }

    var formattedRelativeReleaseInformation: String {
        if let release = releaseDate {
            let currentYear = release.formattedOnlyYear == Date().formattedOnlyYear
            if currentYear {
                return release.formatted
            } else {
                return release.formattedOnlyYear
            }
        } else {
            return String.unknownReleaseDate
        }
    }

    var formattedRuntime: String {
        if runtime != 0 {
            return "\(runtime.formatted ?? String.unknownRuntime) min"
        } else {
            return "\(String.unknownRuntime) min"
        }
    }

    var soonAvailable: Bool {
        if let release = releaseDate,
            release > Date() {
            return true
        } else {
            return false
        }
    }
}
