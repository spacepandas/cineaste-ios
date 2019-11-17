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
        guard let amountOfMovies = try? Importer.importMovies(from: url)
            else { return showAlert(withMessage: Alert.importFailedInfo) }

        showAlert(withMessage: Alert.importSucceededInfo(with: amountOfMovies))
    }
}
