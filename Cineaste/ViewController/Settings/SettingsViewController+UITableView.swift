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
}
