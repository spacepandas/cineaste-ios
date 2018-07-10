//
//  StoredMovie+Formatted.swift
//  Cineaste App-Dev
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension StoredMovie {
    var formattedVoteAverage: String {
        if self.voteCount == 0 {
            return String.unknownVoteAverage
        } else {
            return (self.voteAverage as Decimal?)?.formattedWithOneFractionDigit
                ?? String.unknownVoteAverage
        }
    }

    func formattedReleaseDate(useLongVersion: Bool = false) -> String {
        if let release = localizedReleaseDate,
            let regionName = Locale.current
                .localizedString(forRegionCode: String.regionIso31661) {
            return useLongVersion
                ? "\(release.formatted) (in \(regionName))"
                : release.formatted
        } else if let release = releaseDate {
            return release.formatted
        } else {
            return String.unknownReleaseDate
        }
    }

    var formattedRuntime: String {
        return "\(runtime.formatted ?? String.unknownRuntime) min"
    }

    var formattedWatchedDate: String? {
        guard let watchedDate = watchedDate else { return nil }
        return "\(String.onDate) \(watchedDate.formattedWithTime)"
    }
}
