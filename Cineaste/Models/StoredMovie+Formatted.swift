//
//  StoredMovie+Formatted.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

extension StoredMovie {
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
        let nonbreakingSpace = "\u{00a0}"

        guard runtime != 0 else {
            return "\(String.unknownRuntime)\(nonbreakingSpace)min"
        }

        return "\(runtime.formatted ?? String.unknownRuntime)\(nonbreakingSpace)min"
    }

    var formattedWatchedDate: String? {
        guard let watchedDate = watchedDate else {
            return nil
        }

        return "\(String.onDate) \(watchedDate.formattedWithTime)"
    }
}
