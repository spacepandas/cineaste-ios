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

    var formattedRuntime: String {
        guard runtime != 0 else {
            return "\(String.unknownRuntime) min"
        }

        return "\(runtime.formatted ?? String.unknownRuntime) min"
    }

    var formattedWatchedDate: String? {
        guard let watchedDate = watchedDate else {
            return nil
        }

        return "\(String.onDate) \(watchedDate.formattedWithTime)"
    }
}
