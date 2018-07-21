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
        do {
            let data = try Data(contentsOf: url, options: [])

            //display simple UI when importing new data
            let importMoviesVC = ImportMoviesViewController.instantiate()
            present(importMoviesVC, animated: true) {
                self.fetchedResultsManager.importData(data) { result in
                    DispatchQueue.main.async {
                        self.navigationController?.dismiss(animated: true) {
                            switch result {
                            case .error:
                                self.showAlert(withMessage: Alert.importFailedInfo)
                            case .success(let counter):
                                self.showAlert(withMessage: Alert.importSucceededInfo(with: counter))
                            }
                        }
                    }
                }
            }
        } catch {
            showAlert(withMessage: Alert.importFailedCouldNotReadFile)
        }
    }
}
