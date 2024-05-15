//
//  Strings.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.03.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

// swiftlint:disable line_length
extension String {
    // MARK: DEFAULT
    static let okAction = NSLocalizedString("ok", comment: "Title for ok action")
    static let saveAction = NSLocalizedString("save", comment: "Title for save action")
    static let infoTitle = NSLocalizedString("info", comment: "Title for information")
    static let cancelAction = NSLocalizedString("cancel", comment: "Title for cancel action")
    static let errorTitle = NSLocalizedString("error", comment: "Title for error alert")

    // MARK: MOVIE DETAIL
    static let watchStateSeen = NSLocalizedString("watchStateSeen", comment: "Information watchstate seen")
    static let watchStateWatchlist = NSLocalizedString("watchStateWatchlist", comment: "Information watchstate watchlist")
    static let onTMDB = NSLocalizedString("onTMDB", comment: "Hint for more information on TMDB")

    // MARK: ACTION BUTTONS / SWIPE ACTIONS
    static let watchlistActionLong = NSLocalizedString("watchlistActionLong", comment: "Title for long must see movie button")
    static let watchlistAction = NSLocalizedString("watchlistAction", comment: "Title for must see movie button")
    static let seenActionLong = NSLocalizedString("seenActionLong", comment: "Title for long seen movie button")
    static let seenAction = NSLocalizedString("seen.width", comment: "Title for seen movie button").forWidth
    static let deleteMovie = NSLocalizedString("delete.width", comment: "Title for delete movie button").forWidth
    static let deleteAction = NSLocalizedString("delete", comment: "Title for delete swipe action")
    static let deleteActionLong = NSLocalizedString("deleteFromList", comment: "Title for delete action")
    static let chooseMovie = NSLocalizedString("chooseMovie", comment: "Title for choose movie button")
    static let moreInformation = NSLocalizedString("moreInformation", comment: "Title for the more information button")

    // MARK: VIEWCONTROLLER TITLE
    static let watchlist = NSLocalizedString("watchlist", comment: "Title for want to see movie list")
    static let seen = NSLocalizedString("history", comment: "Title for seen movie list")
    static let searchTitle = NSLocalizedString("search", comment: "Title for search")
    static let moreTitle = NSLocalizedString("settings", comment: "Title for settings viewController")

    // MARK: MOVIES VIEWCONTROLLER
    static func title(for category: MovieListCategory) -> String {
        switch category {
        case .watchlist:
            return NSLocalizedString("noMoviesOnWatchlist", comment: "Description for empty watchlist")
        case .seen:
            return NSLocalizedString("noMoviesOnSeenList", comment: "Description for empty seen list")
        }
    }

    static let searchInCategoryPlaceholder = NSLocalizedString("searchIn", comment: "Placeholder for search textField in MoviesList")
    static let noContentTitle = NSLocalizedString("noContent", comment: "Title for no content")
    static let onDate = NSLocalizedString("onDate", comment: "on a date")
    static let genreAccessibilityLabel = NSLocalizedString("genre", comment: "Genre for a movie")
    static let releasedOnDateAccessibilityLabel = NSLocalizedString("releasedOnDateVoiceOver", comment: "Movie released on dates")
    static let releasedInYearAccessibilityLabel = NSLocalizedString("releasedInYearVoiceOver", comment: "Movie released in year")
    static let releaseOnDateAccessibilityLabel = NSLocalizedString("releaseOnDateVoiceOver", comment: "Release date accessibility label for a movie")

    // MARK: SEARCH VIEWCONTROLLER
    static let discoverMovieTitle = NSLocalizedString("discoverMovieTitle", comment: "Title for search")
    static let soonReleaseInformation = NSLocalizedString("soonRelease", comment: "Information about release")
    static let soonReleaseInformationLong = NSLocalizedString("soonReleaseLong", comment: "Information about release long")

    static func state(for watchState: WatchState) -> String? {
        switch watchState {
        case .undefined:
            return nil
        case .seen:
            return NSLocalizedString("watchStateSeenVoiceOver", comment: "Information watchstate seen")
        case .watchlist:
            return NSLocalizedString("watchStateWatchlist", comment: "Information watchstate watchlist")
        }
    }

    static func voting(for vote: String) -> String {
        String.localizedStringWithFormat(NSLocalizedString("%@ of 10", comment: "Voting description"), vote)
    }

    // MARK: SETTINGS VIEWCONTROLLER ELEMENTS
    static let exportTitle = NSLocalizedString("export", comment: "Title for settings cell exportMovies")
    static let exportDescription = NSLocalizedString("exportDescription", comment: "Description for settings cell exportMovies")
    static let importTitle = NSLocalizedString("import", comment: "Title for settings cell importMovies")
    static let importDescription = NSLocalizedString("importDescription", comment: "Description for settings cell importMovies")
    static let licenseTitle = NSLocalizedString("license", comment: "Title for settings cell licence")
    static let languageTitle = NSLocalizedString("changeLanguage", comment: "Title for settings cell language")
    static let aboutAppTitle = NSLocalizedString("aboutApp", comment: "Title for settings cell about")
    static let contactTitle = NSLocalizedString("contact", comment: "Title for settings cell contact")
    static let appStoreTitle = NSLocalizedString("appStore", comment: "Title for settings cell appStore")
    static let linkToGitHub = NSLocalizedString("linkToGitHub", comment: "Alert sheet option to link to GitHub")
    static let copiedEmailAddress = NSLocalizedString("copyEmailAddress", comment: "Alert sheet option to copy email address")
    static let emailTo = NSLocalizedString("emailTo", comment: "Alert sheet option to write email address")

    // MARK: VERSION INFO
    static let versionText = NSLocalizedString("version", comment: "Description for app version")

    // MARK: CONTENT
    static let imprintContent = NSLocalizedString("aboutContent", comment: "Imprint content")

    static let openSourceTitle = NSLocalizedString("openSource", comment: "Title for openSource")
    static let openSourceDescription = NSLocalizedString("openSourceContent", comment: "Title for openSource")

    static let movieDBTitle = NSLocalizedString("TMDb", comment: "Title for movieDB")
    static let movieDBDescription = NSLocalizedString("TMDbContent", comment: "Description for movieDB")

    static let spacePandasTitle = NSLocalizedString("SpacePandas", comment: "Title for spacePandas")
    static let spacePandasDescription = NSLocalizedString("SpacePandasContent", comment: "Description for spacePandas")

    static let helpPandasTitle = NSLocalizedString("helpPandas", comment: "Title for helpPandas")
    static let littlePandasDescription = NSLocalizedString("helpPandasContent", comment: "Description for helpPandas")

    // MARK: SHORTCUT
    static func movies(for counter: Int) -> String {
        String.localizedStringWithFormat(NSLocalizedString("%d movie(s)", comment: "Movie(s)"), counter)
    }

    // MARK: Empty state
    static let unknownVoteAverage = "-"
    static let unknownRuntime = "-"
    static let unknownReleaseDate = NSLocalizedString("unknown_releaseDate", comment: "Title for unknown release date")

    // MARK: Alert messages

    // import
    static func importSucceededMessage(with counter: Int) -> String {
        let movies = String.localizedStringWithFormat(NSLocalizedString("%d movie(s)", comment: "Movie(s)"), counter)
        let importString = NSLocalizedString("importSuccessfulEnd", comment: "Message for movie import succeeded alert")
        return movies + " " + importString
    }

    static func importProgressMessage(with progressDescription: String) -> String {
        let importString = NSLocalizedString("importProgress", comment: "Message for movie import succeeded alert")
        return progressDescription + " " + importString
    }

    static let importFailedMessage = NSLocalizedString("importFailed", comment: "Message for import failed alert")

    // export
    static let exportFailedMessage = NSLocalizedString("exportFailed", comment: "Message for export failed alert")

    // refresh movie data
    static let refreshMovieData = NSLocalizedString("refresh movie data", comment: "Message for refreshing movie data with pull to refresh")
}
// swiftlint:enable line_length
