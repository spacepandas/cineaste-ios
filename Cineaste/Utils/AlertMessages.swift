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

    init(title: String,
         message: String,
         action: String,
         cancel: String? = nil) {
        self.title = title
        self.message = message
        self.action = action
        self.cancel = cancel
    }
}

class Alert: AlertMessage {
    static let connectionError = AlertMessage(title: String.errorTitle, message: String.connectionErrorMessage, action: String.okAction)
    static let loadingDataError = AlertMessage(title: String.errorTitle, message: String.loadingDataErrorMessage, action: String.okAction)

    static let deleteMovieError = AlertMessage(title: String.errorTitle, message: String.deleteMovieErrorMessage, action: String.okAction)
    static let updateMovieError = AlertMessage(title: String.errorTitle, message: String.updateMovieErrorMessage, action: String.okAction)
    static let insertMovieError = AlertMessage(title: String.errorTitle, message: String.insertMovieErrorMessage, action: String.okAction)

    static let insertUsername = AlertMessage(title: String.usernameTitle, message: String.usernameDescription, action: String.saveAction, cancel: String.cancelAction)

    static let missingFeatureInfo = AlertMessage(title: String.infoTitle, message: String.missingFeatureMessage, action: String.okAction)

    static let askingForImport = AlertMessage(title: String.askForImportTitle, message: String.askForImportMessage, action: String.yesAction, cancel: String.noAction)
    static let importSucceededInfo = AlertMessage(title: String.infoTitle, message: String.importSucceededMessage, action: String.okAction)

    static func importSucceededInfo(with counter: Int) -> AlertMessage {
        return AlertMessage(title: String.infoTitle, message: String.importSucceededMessage(with: counter), action: String.okAction)
    }

    static let importFailedInfo = AlertMessage(title: String.errorTitle, message: String.importFailedMessage, action: String.okAction)
    static let importFailedCouldNotReadFile = AlertMessage(title: String.errorTitle, message: String.importFailedCouldNotReadFileMessage, action: String.okAction)

    static let exportFailedInfo = AlertMessage(title: String.errorTitle, message: String.exportFailedMessage, action: String.okAction)
    static let exportEmptyData = AlertMessage(title: String.infoTitle, message: String.exportWithEmptyDataMessage, action: String.okAction)

    static let noEmailClient = AlertMessage(title: String.infoTitle, message: String.noEmailClientMessage, action: .okAction)
}

extension UIViewController {
    func showAlert(withMessage message: AlertMessage,
                   defaultActionHandler: (() -> Void)? = nil,
                   cancelActionHandler: (() -> Void)? = nil) {
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
