//
//  SettingsViewController+UITableView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit
import MessageUI

extension SettingsViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueCell(identifier: SettingsCell.identifier)
        cell.configure(with: settings[indexPath.row])
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedSetting = settings[indexPath.row]

        guard let setting = selectedSetting else { return }

        switch setting {
        case .about, .licence:
            guard let segue = setting.segue else { return }
            perform(segue: segue, sender: self)
        case .name:
            askForUsername {
                tableView.deselectRow(at: indexPath, animated: true)
                tableView.reloadRows(at: [indexPath], with: .none)
            }
        case .exportMovies:
            tableView.deselectRow(at: indexPath, animated: true)
            exportMovies(showUIOn: tableView.rectForRow(at: indexPath))
        case .importMovies:
            tableView.deselectRow(at: indexPath, animated: true)
            importMovies()
        case .contact:
            if MFMailComposeViewController.canSendMail() {
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                mailComposeVC.setSubject("Cineaste iOS || \(Constants.versionNumberInformation)")
                mailComposeVC.setToRecipients(["ios@spacepandas.de"])

                present(mailComposeVC, animated: true)
            } else {
                showAlert(withMessage: Alert.noEmailClient)
            }
        case .appStore:
            tableView.deselectRow(at: indexPath, animated: true)

            let writeReviewUrl = "\(Constants.appStoreUrl)?action=write-review"
            guard let writeReviewURL = URL(string: writeReviewUrl)
                else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(writeReviewURL, options: [:], completionHandler: nil)
        }
    }

    private func askForUsername(completionHandler: @escaping () -> Void) {
        let alert = UIAlertController(
            title: Alert.username.title,
            message: Alert.username.message,
            preferredStyle: .alert)
        saveAction = UIAlertAction(title: Alert.username.action, style: .default) { _ in
            guard let textField = alert.textFields?[0],
                let username = textField.text
                else { return }

            UserDefaultsManager.setUsername(username)
            completionHandler()
        }

        if let saveAction = saveAction {
            saveAction.isEnabled = UserDefaultsManager.getUsername() != nil
            alert.addAction(saveAction)
        }

        if let cancelTitle = Alert.username.cancel {
            let cancelAction = UIAlertAction(title: cancelTitle, style: .cancel) { _ in
                completionHandler()
            }
            alert.addAction(cancelAction)
        }

        alert.addTextField { textField in
            textField.text = UserDefaultsManager.getUsername()
            textField.placeholder = String.username
            textField.delegate = self
            textField.autocorrectionType = .default
            textField.autocapitalizationType = .words
            textField.textContentType = .givenName
            textField.clearButtonMode = .whileEditing
        }

        present(alert, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        let entryLength = text.count + string.count - range.length
        saveAction?.isEnabled = entryLength > 0

        return true
    }
}
