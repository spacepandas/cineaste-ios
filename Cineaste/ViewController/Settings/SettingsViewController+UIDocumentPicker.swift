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
        let importMoviesVC = ImportMoviesViewController.instantiate()

        //display simple UI when importing new data
        present(importMoviesVC, animated: true) {
            Importer.importMovies(from: url) { result in
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
