//
//  SettingsViewController+UIDocumentPicker.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SettingsViewController: UIDocumentPickerDelegate {
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {

        let importAlert = UIAlertController(
            title: .importTitle,
            message: "",
            preferredStyle: .alert
        )

        present(importAlert, animated: true)

        Importer.importMovies(from: url) { [weak self] result in
            switch result {
            case .success(let importResult):
                let progressDescription = importResult.progress.formattedForPercentage
                    ?? NSNumber(0).formattedForPercentage
                    ?? "0%"
                importAlert.message = String.importProgressMessage(with: progressDescription)

                if importResult.progress == 1 {
                    importAlert.message = String.importSucceededMessage(with: importResult.numberOfMovies)
                    let action = UIAlertAction(
                        title: .okAction,
                        style: .default
                    )
                    importAlert.addAction(action)
                }
            case .failure:
                self?.showAlert(withMessage: Alert.importFailedInfo)
            }
        }
    }
}
