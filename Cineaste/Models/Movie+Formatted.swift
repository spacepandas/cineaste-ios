//
//  Movie+Formatted.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

extension Movie {
    var formattedVoteAverage: String {
        guard voteCount != 0 && voteAverage != 0 else {
            return String.unknownVoteAverage
        }

        return voteAverage.formattedWithOneFractionDigit
            ?? String.unknownVoteAverage
    }

    var formattedReleaseDate: String {
        guard let release = releaseDate else {
            return String.unknownReleaseDate
        }

        return release.formatted
    }

    var formattedRelativeReleaseInformation: String {
        guard let release = releaseDate else {
            return String.unknownReleaseDate
        }

        let isCurrentYear = release.formattedOnlyYear == Date().formattedOnlyYear
        if isCurrentYear {
            return release.formatted
        } else {
            return release.formattedOnlyYear
        }
    }

    var formattedRuntime: String {
        guard runtime != 0 else {
            return "\(String.unknownRuntime) min"
        }

        return "\(runtime?.formatted ?? String.unknownRuntime) min"
    }

    var soonAvailable: Bool {
        guard let release = releaseDate,
            release > Date() else {
                return false
        }

        return true
    }

    var formattedWatchedDate: String? {
        guard let watchedDate = watchedDate else {
            return nil
        }

        return "\(String.onDate) \(watchedDate.formattedWithTime)"
    }
}
