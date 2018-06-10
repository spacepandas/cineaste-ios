//
//  Strings.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.03.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

extension String {
    // MARK: DEFAULT
    static let okAction = NSLocalizedString("OK", comment: "Title for ok action")
    static let saveAction = NSLocalizedString("Speichern", comment: "Title for save action")
    static let infoTitle = NSLocalizedString("Info", comment: "Title for information")
    static let cancelAction = NSLocalizedString("Abbrechen", comment: "Title for cancel action")
    static let yesAction = NSLocalizedString("Ja", comment: "Title for yes action")
    static let noAction = NSLocalizedString("Nein", comment: "Title for no action")
    static let errorTitle = NSLocalizedString("Fehler", comment: "Title for error alert")

    // MARK: ACTION BUTTONS
    static let wantToSee = NSLocalizedString("wantToSee.width", comment: "Title for must see movie button").forWidth
    static let seen = NSLocalizedString("seen.width", comment: "Title for seen movie button").forWidth
    static let deleteMovie = NSLocalizedString("delete.width", comment: "Title for delete movie button").forWidth
    static let startMovieNight = NSLocalizedString("Filmnacht starten", comment: "Title for the start movienight button")

    // MARK: VIEWCONTROLLER TITLE
    static let wantToSeeList = NSLocalizedString("Musst du sehen", comment: "Title for want to see movie list")
    static let seenList = NSLocalizedString("Schon gesehen", comment: "Title for seen movie list")
    static let movieNightTitle = NSLocalizedString("Filmnacht", comment: "Title for movie night viewController")
    static let settingsTitle = NSLocalizedString("Einstellungen", comment: "Title for settings viewController")

    // MARK: MOVIES VIEWCONTROLLER
    static func title(for category: MovieListCategory) -> String {
        return NSLocalizedString(
            """
            Du hast keine Filme auf deiner \"\(category.title)\"-Liste.
            Füge doch einen neuen Titel hinzu.
            """,
            comment: "Description for empty movie list")
    }

    static let onDate = NSLocalizedString("am", comment: "on a date")

    // MARK: TAB TITLE
    static let settingTab = NSLocalizedString("Einstellungen", comment: "TabBar title for setting")

    // MARK: SETTINGS VIEWCONTROLLER ELEMENTS
    static let exportTitle = NSLocalizedString("Export", comment: "Title for settings cell exportMovies")
    static let importTitle = NSLocalizedString("Import", comment: "Title for settings cell importMovies")
    static let licenceTitle = NSLocalizedString("Lizenzen", comment: "Title for settings cell licence")
    static let aboutAppTitle = NSLocalizedString("Über die App", comment: "Title for settings cell about")

    // MARK: VERSION INFO
    static let versionText = NSLocalizedString("Version", comment: "Description for app version")

    // MARK: SWIPE ACTIONS
    static let deleteAction = NSLocalizedString("Löschen", comment: "Title for delete swipe action")
    static let deleteActionLong = NSLocalizedString("Von Liste löschen", comment: "Title for delete action")

    // MARK: CONTENT
    static let imprintContent = NSLocalizedString(
        """
        Cineaste ist der bequemste Weg das richtige Bewegtbild für einen \
        entspannten Filmabend zu finden. Hier kannst du alle Filme, die du \
        noch sehen möchtest, oder schon gesehen hast, einfach und \
        übersichtlich verwalten.

        Ein einziger Klick findet bei deinem nächsten Filmabend den Titel, \
        welchen die meisten Anwesenden sehen wollen. Hierbei werden deine \
        Filme über Bluetooth nur in deinem Wohnzimmer geteilt. Ist der \
        passende Titel gefunden, können deine Freunde deine Filme nicht mehr \
        sehen. Das heißt, dass deine Filmlisten zu keinem Zeitpunkt über \
        irgendwelche Server gehen und sicher auf deinem Gerät liegen.

        Solltest du doch einmal deine Filmlisten dauerhaft zu einem anderen \
        Gerät übertragen wollen, kannst du sie problemlos exportieren und \
        importieren.
        """,
        comment: "Imprint content")

    static let openSourceTitle = NSLocalizedString("Open Source Projekt", comment: "Title for openSource")
    static let openSourceDescription = NSLocalizedString(
        """
        Cineaste startete 2016 mit einer Android App und seit Ende 2017 \
        arbeiten die SpacePandas nun auch an der längst überfälligen iOS App. \
        Und weil wir absolut nichts zu verbergen haben ist Cineaste Open \
        Source. Das heißt jeder kann unseren Code sehen und etwas zu der App \
        beitragen.

        Wir geben unser Bestes, um das Nutzererlebnis so gut wie möglich zu \
        machen, dabei sind wir aber auf dein Feedback angewiesen. Schreib doch \
        einen Kommentar im App Store oder schau auf GitHub vorbei.

        Android App - GitHub: github.com/marcelgross90/Cineaste
        iOS App - GitHub: github.com/ChristianNorbertBraun/Cineaste

        Besonderer Dank geht an Philipp Wolf für das Design!
        """,
        comment: "Title for openSource")

    static let movieDBTitle = NSLocalizedString("TMDb", comment: "Title for movieDB")
    static let movieDBDescription = NSLocalizedString(
        """
        Das Wissen über die ganzen Filme haben wir übrigens von TMDb \
        (www.themoviedb.org).

        Diese App nutzt die TMDb API, wird jedoch nicht durch TMDb unterstützt \
        oder zertifiziert.
        """,
        comment: "Description for movieDB")

    // MARK: SHORTCUT
    static func movies(for counter: Int) -> String {
        return String.localizedStringWithFormat(NSLocalizedString("%d movie(s)", comment: "Movie(s)"), counter)
    }

    // MARK: MOVIENIGHT
    static func matches(for number: Int, amountOfPeople: Int) -> String {
        return NSLocalizedString("\(number) von \(amountOfPeople)", comment: "Number of matches description")
    }

    // MARK: EXPORT
    static let exportMoviesFileName = "movies.json"
    static let exportMoviesFileUTI = "public.json"

    // MARK: Empty state
    static let unknownVoteCount = "-.-"
    static let unknownVoteAverage = "-.-"
    static let unknownRuntime = "-.-"
    static let unknownReleaseDate = NSLocalizedString("Unbekannt", comment: "Title for unknown release date")

    // MARK: Alert messages

    // connection error
    static let connectionErrorMessage = NSLocalizedString("Verbindung zur Filmdatenbank fehlgeschlagen.", comment: "Message for connection error alert")
    static let loadingDataErrorMessage = NSLocalizedString("Die Daten konnten nicht geladen werden.", comment: "Message for loading data error alert")

    // core data error
    static let deleteMovieErrorMessage = NSLocalizedString("Der Film konnte nicht gelöscht werden.", comment: "Message for delete movie error alert")
    static let updateMovieErrorMessage = NSLocalizedString("Der Film konnte nicht verschoben werden.", comment: "Message for update movie error alert")
    static let insertMovieErrorMessage = NSLocalizedString("Der Film konnte nicht eingefügt werden.", comment: "Message for insert movie error alert")

    // enter username for movie night
    static let usernameTitle = NSLocalizedString("Benutzername", comment: "Enter username title")
    static let usernameDescription = NSLocalizedString("Gib einen Namen an, unter dem dich deine Freunde sehen können.", comment: "Enter username description")

    // missing feature
    static let missingFeatureMessage = NSLocalizedString("Dieses Feature wurde noch nicht implementiert.", comment: "Message for missing feature alert")

    // import
    static let askForImportTitle = NSLocalizedString("Bist du sicher?", comment: "Title for asking for import alert")
    static let askForImportMessage = NSLocalizedString(
        """
        Möchtest du deine bisherigen Daten wirklich mit Neuen überschreiben?
        Die alten Daten werden unwiderruflich gelöscht.
        """,
        comment: "Message for asking for import alert")
    static let importSucceededMessage = NSLocalizedString("Import erfolgreich", comment: "Message for import succeeded alert")

    static func importSucceededMessage(with counter: Int) -> String {
        let movies = String.localizedStringWithFormat(NSLocalizedString("%d movie(s)", comment: "Movie(s)"), counter)
        let importString = NSLocalizedString("erfolgreich importiert.", comment: "Message for movie import succeeded alert")
        return movies + " " + importString
    }

    static let importFailedMessage = NSLocalizedString("Import fehlgeschlagen", comment: "Message for import failed alert")
    static let importFailedCouldNotReadFileMessage = NSLocalizedString("Import fehlgeschlagen\nDie Datei konnte nicht gelesen werden.", comment: "Message for import failed because the file could not be read alert")

    // export
    static let exportFailedMessage = NSLocalizedString("Export fehlgeschlagen", comment: "Message for export failed alert")
    static let exportWithEmptyDataMessage = NSLocalizedString("Deine Datenbank ist leer. Füge Filme zu deiner Watchlist hinzu, dann kannst du diese auch exportieren.", comment: "Message for export with empty data alert")
}
