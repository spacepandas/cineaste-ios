//
//  AlertMessages.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class AlertMessage {
    var title: String
    var message: String
    var action: String
    var cancel: String?

    init(title: String, message: String, action: String, cancel: String? = nil) {
        self.title = title
        self.message = message
        self.action = action
        self.cancel = cancel
    }
}

// default
private let okAction = NSLocalizedString("OK", comment: "Title for ok action")
private let saveAction = NSLocalizedString("Speichern", comment: "Title for save action")
private let infoTitle = NSLocalizedString("Info", comment: "Title for information")
private let cancelAction = NSLocalizedString("Abbrechen", comment: "Title for cancel action")
private let yesAction = NSLocalizedString("Ja", comment: "Title for yes action")
private let noAction = NSLocalizedString("Nein", comment: "Title for no action")

// error
private let errorTitle = NSLocalizedString("Fehler", comment: "Title for error alert")

// connection error
private let connectionErrorMessage = NSLocalizedString("Verbindung zur Filmdatenbank fehlgeschlagen.", comment: "Message for connection error alert")
private let loadingDataErrorMessage = NSLocalizedString("Die Daten konnten nicht geladen werden.", comment: "Message for loading data error alert")

// core data error
private let deleteMovieErrorMessage = NSLocalizedString("Der Film konnte nicht gelöscht werden.", comment: "Message for delete movie error alert")
private let updateMovieErrorMessage = NSLocalizedString("Der Film konnte nicht verschoben werden.", comment: "Message for update movie error alert")
private let insertMovieErrorMessage = NSLocalizedString("Der Film konnte nicht eingefügt werden.", comment: "Message for insert movie error alert")

// enter username for movie night
private let usernameTitle = NSLocalizedString("Enter a username", comment: "Enter username heading")
private let usernameDescription = NSLocalizedString("How do you want to appear on your friends", comment: "Enter username description")

// missing feature
private let missingFeatureMessage = NSLocalizedString("Dieses Feature wurde noch nicht implementiert.", comment: "Message for missing feature alert")

// import
private let askForImportTitle = NSLocalizedString("Bist du sicher?", comment: "Title for asking for import alert")
private let askForImportMessage = NSLocalizedString("Möchtest du deine bisherigen Daten wirklich mit Neuen überschreiben?\nDie alten Daten werden unwiderruflich gelöscht.", comment: "Message for asking for import alert")
private let importSucceededMessage = NSLocalizedString("Import erfolgreich", comment: "Message for import succeeded alert")

private func importSucceededMessage(with counter: Int) -> String {
    if counter == 1 {
        return NSLocalizedString("\(counter) Film erfolgreich importiert", comment: "Message for one movie import succeeded alert")
    }
    return NSLocalizedString("\(counter) Filme erfolgreich importiert", comment: "Message for import succeeded alert with counter")
}

private let importFailedMessage = NSLocalizedString("Import fehlgeschlagen", comment: "Message for import failed alert")
private let importFailedCouldNotReadFileMessage = NSLocalizedString("Import fehlgeschlagen\nDie Datei konnte nicht gelesen werden.", comment: "Message for import failed because the file could not be read alert")

// export
private let exportFailedMessage = NSLocalizedString("Export fehlgeschlagen", comment: "Message for export failed alert")
private let exportWithEmptyDataMessage = NSLocalizedString("Deine Datenbank ist leer. Füge Filme zu deiner Watchlist hinzu, dann kannst du diese auch exportieren.", comment: "Message for export with empty data alert")

class Alert: AlertMessage {
    static let connectionError = AlertMessage(title: errorTitle, message: connectionErrorMessage, action: okAction)
    static let loadingDataError = AlertMessage(title: errorTitle, message: loadingDataErrorMessage, action: okAction)

    static let deleteMovieError = AlertMessage(title: errorTitle, message: deleteMovieErrorMessage, action: okAction)
    static let updateMovieError = AlertMessage(title: errorTitle, message: updateMovieErrorMessage, action: okAction)
    static let insertMovieError = AlertMessage(title: errorTitle, message: insertMovieErrorMessage, action: okAction)

    static let insertUsername = AlertMessage(title: usernameTitle, message: usernameDescription, action: saveAction, cancel: cancelAction)

    static let missingFeatureInfo = AlertMessage(title: infoTitle, message: missingFeatureMessage, action: okAction)

    static let askingForImport = AlertMessage(title: askForImportTitle, message: askForImportMessage, action: yesAction, cancel: noAction)
    static let importSucceededInfo = AlertMessage(title: infoTitle, message: importSucceededMessage, action: okAction)

    static func importSucceededInfo(with counter: Int) -> AlertMessage {
        return AlertMessage(title: infoTitle, message: importSucceededMessage(with: counter), action: okAction)
    }

    static let importFailedInfo = AlertMessage(title: errorTitle, message: importFailedMessage, action: okAction)
    static let importFailedCouldNotReadFile = AlertMessage(title: errorTitle, message: importFailedCouldNotReadFileMessage, action: okAction)

    static let exportFailedInfo = AlertMessage(title: errorTitle, message: exportFailedMessage, action: okAction)
    static let exportEmptyData = AlertMessage(title: infoTitle, message: exportWithEmptyDataMessage, action: okAction)
}

extension UIViewController {
    func showAlert(withMessage message: AlertMessage, defaultActionHandler: (() -> Void)? = nil, cancelActionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(message)
        let action = UIAlertAction(title: message.action, style: .default) { _ in
            defaultActionHandler?()
        }
        alert.addAction(action)

        if let cancelTitle = message.cancel {
            let action = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelActionHandler?()
            }
            alert.addAction(action)
        }

        DispatchQueue.main.async {
            self.present(alert, animated: true)
        }
    }
}

private extension UIAlertController {
    convenience init(_ message: AlertMessage) {
        self.init(title: message.title,
                  message: message.message,
                  preferredStyle: .alert)
    }
}
