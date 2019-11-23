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

    // swiftlint:disable:next cyclomatic_complexity
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        selectedSetting = settings[indexPath.row]
        guard let setting = selectedSetting else { return }

        switch setting {
        case .about, .licence:
            guard let segue = setting.segue else { return }
            perform(segue: segue, sender: self)
        case .language:
            guard let url = URL(string: UIApplication.openSettingsURLString)
                else { fatalError("Expected a valid URL") }
            UIApplication.shared.open(url, options: [:])
        case .name:
            let alert = UsernameAlert.askForUsernameAlertController(
                presenter: self,
                onSave: {
                    self.reloadUsernameCell()
                })
            present(alert, animated: true)
        case .exportMovies:
            exportMovies(showUIOn: tableView.rectForRow(at: indexPath))
        case .importMovies:
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
            AppStoreReview.openWriteReviewURL()
        }
    }
}
