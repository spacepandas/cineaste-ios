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
        Importer.importMovies(from: url) { [weak self] result in
            switch result {
            case .success(let amountOfMovies):
                self?.showAlert(withMessage: Alert.importSucceededInfo(with: amountOfMovies))
            case .failure:
                self?.showAlert(withMessage: Alert.importFailedInfo)
            }
        }
    }
}
