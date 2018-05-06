//
//  Strings.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.03.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

struct Strings {
    // MARK: ACTION BUTTONS
    static let wantToSeeButton = NSLocalizedString("Muss ich sehen", comment: "Title for must see movie button")
    static let seenButton = NSLocalizedString("Schon gesehen", comment: "Title for seen movie button")
    static let deleteButton = NSLocalizedString("Von Liste löschen", comment: "Title for delete movie button")

    // MARK: VIEWCONTROLLER TITLE
    static let wantToSeeList = NSLocalizedString("Musst du sehen", comment: "Title for want to see movie list")
    static let seenList = NSLocalizedString("Schon gesehen", comment: "Title for seen movie list")
    static let movieNightTitle = NSLocalizedString("Movie-Night", comment: "Title for movie night viewController")
    static let settingsTitle = NSLocalizedString("Einstellungen", comment: "Title for settings viewController")

    // MARK: MOVIES VIEWCONTROLLER
    static func title(for category: MovieListCategory) -> String {
        return NSLocalizedString("Du hast keine Filme auf deiner \"\(category.title)\"-Liste.\nFüge doch einen neuen Titel hinzu.",
            comment: "Description for empty movie list")
    }

    // MARK: TAB TITLE
    static let wantToSeeTab = NSLocalizedString("Musst du sehen", comment: "TabBar title for want to see movie list")
    static let seenTab = NSLocalizedString("Schon gesehen", comment: "TabBar title for seen movie list")
    static let settingTab = NSLocalizedString("Einstellungen", comment: "TabBar title for setting")

    // MARK: SETTINGS VIEWCONTROLLER ELEMENTS
    static let exportTitle = NSLocalizedString("Export", comment: "Title for settings cell exportMovies")
    static let importTitle = NSLocalizedString("Import", comment: "Title for settings cell importMovies")
    static let licenceTitle = NSLocalizedString("Lizenzen", comment: "Title for settings cell licence")
    static let aboutAppTitle = NSLocalizedString("Über die App", comment: "Title for settings cell about")

    // MARK: VERSION INFO
    static let versionText = NSLocalizedString("Version", comment: "Description for app version")

    // MARK: SWIPE ACTIONS
    static let deleteActionTitle = NSLocalizedString("Löschen", comment: "Title for delete swipe action")

    // MARK: CONTENT
    //swiftlint:disable line_length
    static let imprintContent = """
    Cineaste ist ein Open Source Projekt von zwei Informatik Studenten. Das Kernfeature der App liegt darin, möglichst leicht Filme für einen gemeinsamen Filmeabend zu finden. Über den "Matching"-Button sucht dein Handy nach Freunden in deiner Umgebung und findet Filme, die ihr Alle sehen wollt.\n\nDie Daten werden dabei über Bluetooth übertragen. Das heißt, dass deine Filmlisten zu jedem Zeitpunkt sicher auf deinem Gerät sind und dort auch bleiben. Daten werden also nur innerhalb deines Wohnzimmers ausgetauscht.\n\nCineaste befindet sich noch im Anfangsstadium und könnte manchmal nicht richtig funktionieren. Natürlich geben wir unser Bestes um das Erlebnis so gut wie möglich zu machen, dabei sind wir aber auf dein Feedback angewiesen. Schreib doch einfach ein Kommentar im Play Store oder entwickle einfach gemeinsam mit uns Cineaste weiter! Dazu findest du unten das GitHub Icon. Für die Filme zapfen wir übrigens TheMovieDb an. Auch hier kannst du über das Icon mal vorbeischaun.\n\nBesonderer Dank geht an Philipp Wolf für das Design!
    """

    static let licenceContent = """
    Lorem ipsum dolor sit er elit lamet, consectetaur cillium adipisicing pecu, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum. Nam liber te conscient to factor tum poen legum odioque civiuda.
    """
    //swiftlint:enable line_length

    // MARK: SHORTCUT
    static let oneMovieShortCut = NSLocalizedString("Film", comment: "Movie")
    static let movieCounterShortCut = NSLocalizedString("Filme", comment: "Movies")

    // MARK: EXPORT
    static let exportMoviesFileName = "movies.json"
    static let exportMoviesFileUTI = "public.json"

    // MARK: Empty state
    static let unknownVoteCount = "-.-"
    static let unknownVoteAverage = "-.-"
    static let unknownRuntime = "-.-"
    static let unknownReleaseDate = NSLocalizedString("Unbekannt", comment: "Title for unknown release date")
}
