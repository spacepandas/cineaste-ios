//
//  AlertMessage.swift
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
    static let connectionError =
        AlertMessage(title: .errorTitle,
                     message: .connectionErrorMessage,
                     action: .okAction)
    static let loadingDataError =
        AlertMessage(title: .errorTitle,
                     message: .loadingDataErrorMessage,
                     action: .okAction)

    static let deleteMovieError =
        AlertMessage(title: .errorTitle,
                     message: .deleteMovieErrorMessage,
                     action: .okAction)
    static let updateMovieError =
        AlertMessage(title: .errorTitle,
                     message: .updateMovieErrorMessage,
                     action: .okAction)
    static let insertMovieError =
        AlertMessage(title: .errorTitle,
                     message: .insertMovieErrorMessage,
                     action: .okAction)

    static let username =
        AlertMessage(title: .username,
                     message: .usernameDescription(),
                     action: .saveAction,
                     cancel: .cancelAction)

    static let missingFeatureInfo =
        AlertMessage(title: .infoTitle,
                     message: .missingFeatureMessage,
                     action: .okAction)

    static func importSucceededInfo(with counter: Int) -> AlertMessage {
        return AlertMessage(title: .infoTitle,
                            message: .importSucceededMessage(with: counter),
                            action: .okAction)
    }

    static let importFailedInfo =
        AlertMessage(title: .errorTitle,
                     message: .importFailedMessage,
                     action: .okAction)
    static let importFailedCouldNotReadFile =
        AlertMessage(title: .errorTitle,
                     message: .importFailedCouldNotReadFileMessage,
                     action: .okAction)

    static let exportFailedInfo =
        AlertMessage(title: .errorTitle,
                     message: .exportFailedMessage,
                     action: .okAction)
    static let exportEmptyData =
        AlertMessage(title: .infoTitle,
                     message: .exportWithEmptyDataMessage,
                     action: .okAction)

    static let noEmailClient =
        AlertMessage(title: .infoTitle,
                     message: .noEmailClientMessage,
                     action: .okAction)
}

extension UIViewController {
    func showAlert(withMessage message: AlertMessage,
                   defaultActionHandler: (() -> Void)? = nil,
                   cancelActionHandler: (() -> Void)? = nil) {

        let alert = UIAlertController(message)
        let action = UIAlertAction(title: message.action,
                                   style: .default) { _ in
            defaultActionHandler?()
        }
        alert.addAction(action)

        if let cancelTitle = message.cancel {
            let action = UIAlertAction(title: cancelTitle,
                                       style: .cancel) { _ in
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
