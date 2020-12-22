//
//  AlertMessage.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

struct AlertMessage {
    var title: String
    var message: String
    var action: String
    var cancel: String?
}

enum Alert {
    static let importFailedInfo = AlertMessage(
        title: .errorTitle,
        message: .importFailedMessage,
        action: .okAction
    )
    static let exportFailedInfo = AlertMessage(
        title: .errorTitle,
        message: .exportFailedMessage,
        action: .okAction
    )

    static func importSucceededInfo(with counter: Int) -> AlertMessage {
        AlertMessage(
            title: .infoTitle,
            message: .importSucceededMessage(with: counter),
            action: .okAction
        )
    }
}

extension UIViewController {
    func showAlert(withMessage message: AlertMessage, defaultActionHandler: (() -> Void)? = nil, cancelActionHandler: (() -> Void)? = nil) {

        let alert = UIAlertController(message)
        let action = UIAlertAction(
            title: message.action,
            style: .default) { _ in
                defaultActionHandler?()
        }
        alert.addAction(action)

        if let cancelTitle = message.cancel {
            let action = UIAlertAction(
                title: cancelTitle,
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
        self.init(
            title: message.title,
            message: message.message,
            preferredStyle: .alert
        )
    }
}
