//
//  UsernameAlert.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 02.06.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

enum UsernameAlert {
    static var saveAction: UIAlertAction?

    static func askForUsernameAlertController(
        presenter: UITextFieldDelegate,
        onSave: @escaping () -> Void,
        onCancel: (() -> Void)? = nil
        ) -> UIAlertController {

        let message: String = UserDefaults.standard.username != nil
            ? .changeUsernameDescription
            : .insertUsernameDescription

        let alert = UIAlertController(
            title: Alert.username.title,
            message: message,
            preferredStyle: .alert
        )

        saveAction = UIAlertAction(
            title: Alert.username.action,
            style: .default
        ) { _ in
            guard let textField = alert.textFields?[0],
                let username = textField.text
                else { return }

            let trimmedName = username.trimmingCharacters(in: .whitespaces)
            UserDefaults.standard.username = trimmedName

            saveAction = nil

            onSave()
        }

        if let saveAction = saveAction {
            saveAction.isEnabled = UserDefaults.standard.username != nil
            alert.addAction(saveAction)
        }

        if let cancelTitle = Alert.username.cancel {
            let cancelAction = UIAlertAction(
                title: cancelTitle,
                style: .cancel
            ) { _ in

                saveAction = nil

                onCancel?()
            }
            alert.addAction(cancelAction)
        }

        alert.addTextField { textField in
            textField.text = UserDefaults.standard.username
            textField.placeholder = String.username
            textField.delegate = presenter
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .words
            textField.textContentType = .givenName
            textField.clearButtonMode = .whileEditing
        }

        return alert
    }
}
