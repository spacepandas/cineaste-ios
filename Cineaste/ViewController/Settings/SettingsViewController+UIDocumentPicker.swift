//
//  SettingsViewController+UIDocumentPicker.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 21.07.18.
//  Copyright © 2018 spacepandas.de. All rights reserved.
//

import UIKit

extension SettingsViewController: UIDocumentPickerDelegate {
    //selected json with movies to import
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        guard let storageManager = storageManager else {
            fatalError("No storageManager injected")
        }

        //display simple UI when importing new data
        let importMoviesVC = ImportMoviesViewController.instantiate()
        present(importMoviesVC, animated: true) {
            Importer.importMovies(from: url, storageManager: storageManager) { result in
                DispatchQueue.main.async {
                    self.navigationController?.dismiss(animated: true) {
                        switch result {
                        case .failure:
                            self.showAlert(withMessage: Alert.importFailedInfo)
                        case .success(let counter):
                            self.showAlert(withMessage: Alert.importSucceededInfo(with: counter))
                        }
                    }
                }
            }
        }
    }
}
