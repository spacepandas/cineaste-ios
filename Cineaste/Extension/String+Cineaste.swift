//
//  Strings.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.03.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

//swiftlint:disable line_length
extension String {
    // MARK: DEFAULT
    static let okAction = NSLocalizedString("ok", comment: "Title for ok action")
    static let saveAction = NSLocalizedString("save", comment: "Title for save action")
    static let infoTitle = NSLocalizedString("info", comment: "Title for information")
    static let cancelAction = NSLocalizedString("cancel", comment: "Title for cancel action")
    static let yesAction = NSLocalizedString("yes", comment: "Title for yes action")
    static let noAction = NSLocalizedString("no", comment: "Title for no action")
    static let errorTitle = NSLocalizedString("error", comment: "Title for error alert")

    // MARK: MOVIE DETAIL
    static let watchStateSeen = NSLocalizedString("watchStateSeen", comment: "Information watchstate seen")
    static let watchStateWatchlist = NSLocalizedString("watchStateWatchlist", comment: "Information watchstate watchlist")
    static let onTMDB = NSLocalizedString("onTMDB", comment: "Hint for more information on TMDB")

    // MARK: ACTION BUTTONS
    static let watchlistActionLong = NSLocalizedString("watchlistActionLong", comment: "Title for long must see movie button")
    static let watchlistAction = NSLocalizedString("watchlistAction", comment: "Title for must see movie button")
    static let seenAction = NSLocalizedString("seen.width", comment: "Title for seen movie button").forWidth
    static let deleteMovie = NSLocalizedString("delete.width", comment: "Title for delete movie button").forWidth
    static let startMovieNight = NSLocalizedString("startMovieNight", comment: "Title for the start movienight button")
    static let chooseMovie = NSLocalizedString("chooseMovie", comment: "Title for choose movie button")
    static let moreInformation = NSLocalizedString("moreInformation", comment: "Title for the more information button")

    // MARK: VIEWCONTROLLER TITLE
    static let watchlist = NSLocalizedString("watchlist", comment: "Title for want to see movie list")
    static let seen = NSLocalizedString("history", comment: "Title for seen movie list")
    static let movieNightTitle = NSLocalizedString("movieNight", comment: "Title for movie night viewController")
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

    static let noContentTitle = NSLocalizedString("noContent", comment: "Title for no content")
    static let onDate = NSLocalizedString("onDate", comment: "on a date")

    // MARK: SEARCH VIEWCONTROLLER
    static let addMovieTitle = NSLocalizedString("searchMovieTitle", comment: "Title for search")
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
        return String.localizedStringWithFormat(NSLocalizedString("%@ of 10", comment: "Voting description"), vote)
    }

    // MARK: SETTINGS VIEWCONTROLLER ELEMENTS
    static let exportTitle = NSLocalizedString("export", comment: "Title for settings cell exportMovies")
    static let exportDescription = NSLocalizedString("exportDescription", comment: "Description for settings cell exportMovies")
    static let importTitle = NSLocalizedString("import", comment: "Title for settings cell importMovies")
    static let importDescription = NSLocalizedString("importDescription", comment: "Description for settings cell importMovies")
    static let licenseTitle = NSLocalizedString("license", comment: "Title for settings cell licence")
    static let aboutAppTitle = NSLocalizedString("aboutApp", comment: "Title for settings cell about")
    static let contactTitle = NSLocalizedString("contact", comment: "Title for settings cell contact")
    static let appStoreTitle = NSLocalizedString("appStore", comment: "Title for settings cell appStore")

    // MARK: VERSION INFO
    static let versionText = NSLocalizedString("version", comment: "Description for app version")

    // MARK: SWIPE ACTIONS
    static let deleteAction = NSLocalizedString("delete", comment: "Title for delete swipe action")
    static let deleteActionLong = NSLocalizedString("deleteFromList", comment: "Title for delete action")

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

    static let icons8Title = NSLocalizedString("icons8", comment: "Title for icons8")
    static let icons8Description = NSLocalizedString("icons8link", comment: "Description for icons8")

    // MARK: SHORTCUT
    static func movies(for counter: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d movie(s)", comment: "Movie(s)"), counter)
    }

    // MARK: MOVIENIGHT
    static func matches(for number: Int, amountOfPeople: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d of %d", comment: "Number of matches description"), number, amountOfPeople)
    }

    static let searchFriendsOnMovieNight = NSLocalizedString("searchFriends", comment: "Search friends on movie night")
    static let resultsForMovieNight = NSLocalizedString("results", comment: "Results after search for movie night")
    static let allResultsForMovieNight = NSLocalizedString("results all together", comment: "All results for movie night")
    static let enableNearby = NSLocalizedString("enable nearby", comment: "Title for enable nearby button")
    static let nearbyUsage = NSLocalizedString("nearbyUsage", comment: "Description for usage of nearby")
    static let nearbyPermissionDenied = NSLocalizedString("nearbyPermissionDenied", comment: "Description for denied nearby permission")
    static let nearbyLink = NSLocalizedString("nearbyLink", comment: "Nearby link")

    // MARK: IMPORT
    static let importingMovies = NSLocalizedString("importingMovies", comment: "Description while importing movies")

    // MARK: EXPORT
    static func exportMoviesFileName(with date: String) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("cineaste-\(date).json", comment: "export movies json name"), date)
    }

    static let exportMoviesFileUTI = "public.json"

    // MARK: Empty state
    static let unknownVoteCount = "-"
    static let unknownVoteAverage = "-"
    static let unknownRuntime = "-"
    static let unknownTitle = NSLocalizedString("unknown_title", comment: "Title for unknown title")
    static let unknownReleaseDate = NSLocalizedString("unknown_releaseDate", comment: "Title for unknown release date")

    // MARK: Alert messages

    // connection error
    static let connectionErrorMessage = NSLocalizedString("connectionError", comment: "Message for connection error alert")
    static let loadingDataErrorMessage = NSLocalizedString("loadingDataError", comment: "Message for loading data error alert")

    // core data error
    static let deleteMovieErrorMessage = NSLocalizedString("couldNotDeleteMovie", comment: "Message for delete movie error alert")
    static let updateMovieErrorMessage = NSLocalizedString("couldNotMoveMovie", comment: "Message for update movie error alert")
    static let insertMovieErrorMessage = NSLocalizedString("couldNotAddMovie", comment: "Message for insert movie error alert")

    // enter username for movie night
    static let username = NSLocalizedString("username", comment: "Enter username title")
    static let insertUsernameDescription = NSLocalizedString("explainMovieNight", comment: "Explain movie night description")
    static let changeUsernameDescription = NSLocalizedString("changeUsername", comment: "Change username description")

    static var usernameDescription: String {
        if let name = UserDefaultsManager.username, !name.isEmpty {
            return .changeUsernameDescription
        } else {
            return .insertUsernameDescription
        }
    }

    // missing feature
    static let missingFeatureMessage = NSLocalizedString("missingFeature", comment: "Message for missing feature alert")

    // import
    static func importSucceededMessage(with counter: Int) -> String {
        let movies = String.localizedStringWithFormat(NSLocalizedString("%d movie(s)", comment: "Movie(s)"), counter)
        let importString = NSLocalizedString("importSuccessfulEnd", comment: "Message for movie import succeeded alert")
        return movies + " " + importString
    }

    static let importFailedMessage = NSLocalizedString("importFailed", comment: "Message for import failed alert")
    static let importFailedCouldNotReadFileMessage = NSLocalizedString("importFailedNotReadFile", comment: "Message for import failed because the file could not be read alert")

    // export
    static let exportFailedMessage = NSLocalizedString("exportFailed", comment: "Message for export failed alert")
    static let exportWithEmptyDataMessage = NSLocalizedString("emptyDatabase", comment: "Message for export with empty data alert")

    static let noEmailClientMessage = NSLocalizedString("noEmailClient", comment: "Message for no email client alert")

    // refresh movie data
    static let refreshMovieData = NSLocalizedString("refresh movie data", comment: "Message for refreshing movie data with pull to refresh")
}
//swiftlint:enable line_length
