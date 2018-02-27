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
private let cancelAction = NSLocalizedString("Abbrechen", comment: "Title for cancel action")

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

class Alert: AlertMessage {
    static let connectionError = AlertMessage(title: errorTitle, message: connectionErrorMessage, action: okAction)
    static let loadingDataError = AlertMessage(title: errorTitle, message: loadingDataErrorMessage, action: okAction)

    static let deleteMovieError = AlertMessage(title: errorTitle, message: deleteMovieErrorMessage, action: okAction)
    static let updateMovieError = AlertMessage(title: errorTitle, message: updateMovieErrorMessage, action: okAction)
    static let insertMovieError = AlertMessage(title: errorTitle, message: insertMovieErrorMessage, action: okAction)

    static let insertUsername = AlertMessage(title: usernameTitle, message: usernameDescription, action: saveAction, cancel: cancelAction)
}

extension UIViewController {
    func showAlert(withMessage message: AlertMessage, defaultActionHandler: (() -> Void)? = nil, cancelActionHandler: (() -> Void)? = nil) {
        let alert = UIAlertController(message)
        let action = UIAlertAction(title: message.action, style: .default) { _ in
            defaultActionHandler?()
        }
        alert.addAction(action)

        if let cancelTitle = message.cancel, let cancelAction = cancelActionHandler {
            let action = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                cancelAction()
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
