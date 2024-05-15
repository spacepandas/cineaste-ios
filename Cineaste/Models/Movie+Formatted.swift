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

        return String(format: "%.1f", voteAverage)
    }

    var formattedReleaseDate: String {
        guard let release = releaseDate else {
            return String.unknownReleaseDate
        }

        return release.formatted
    }

    var accessibilityFormattedReleaseDate: String {
        guard let release = releaseDate else {
            return String.unknownReleaseDate
        }

        return String.releasedOnDateAccessibilityLabel + " " + formattedReleaseDate
    }

    var formattedRelativeReleaseInformation: String {
        guard let release = releaseDate else {
            return String.unknownReleaseDate
        }

        let isCurrentYear = release.formattedOnlyYear == Current.date().formattedOnlyYear
        if isCurrentYear {
            return release.formatted
        } else {
            return release.formattedOnlyYear
        }
    }

    // swiftlint:disable:next identifier_name
    var accessibilityFormattedRelativeReleaseInformation: String {
        guard let release = releaseDate else {
            return String.unknownReleaseDate
        }

        let isCurrentYear = release.formattedOnlyYear == Current.date().formattedOnlyYear
        if isCurrentYear {
            if soonAvailable {
                // Release on May 4, 2030
                return String.releaseOnDateAccessibilityLabel + " " + release.formatted
            } else {
                // Released on May 4, 2023
                return String.releasedOnDateAccessibilityLabel + " " + release.formatted
            }
        } else {
            // Released in 2024
            return String.releasedInYearAccessibilityLabel + " " + release.formattedOnlyYear
        }
    }

    var formattedRuntime: String {
        guard let runtime else {
            return "\(String.unknownRuntime) min"
        }

        if #available(iOS 16.0, *) {
            let duration = Duration.seconds(runtime * 60)
            let format = duration.formatted(.units(allowed: [.minutes], width: .abbreviated))
            return format
        } else {
            return "\(runtime.formatted ?? String.unknownRuntime) min"
        }
    }

    var formattedWatchedDate: String? {
        guard let watchedDate = watchedDate else {
            return nil
        }

        return "\(String.onDate) \(watchedDate.formattedWithTime)"
    }

    var formattedGenres: String {
        genres
            .sorted(by: SortDescriptor.sortByGenreName)
            .map { $0.name }
            .joined(separator: ", ")
    }
}
