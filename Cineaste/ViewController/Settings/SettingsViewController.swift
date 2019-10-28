//
//  SettingsViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet private weak var footerView: UIView!
    @IBOutlet private weak var versionInfo: DescriptionLabel!

    var settings: [SettingItem] {
        if #available(iOS 13.0, *) {
            return SettingItem.allCases
        } else {
            // Setting "Change Language" is not available pre iOS 13
            return SettingItem.allCasesForPreIOS13
        }
    }
    var selectedSetting: SettingItem?

    var storageManager: MovieStorageManager?
    var docController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.moreTitle

        tableView.backgroundColor = UIColor.cineListBackground
        tableView.tableFooterView = footerView

        versionInfo.text = Constants.versionNumberInformation
        versionInfo.textColor = .cineDescription
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        reloadUsernameCell()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()

        guard let footerView = tableView.tableFooterView else { return }
        let height = footerView
            .systemLayoutSizeFitting(UIView.layoutFittingCompressedSize)
            .height
        var footerFrame = footerView.frame

        if height != footerFrame.size.height {
            footerFrame.size.height = height
            footerView.frame = footerFrame
            tableView.tableFooterView = footerView
        }
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showTextViewFromSettings?:
            guard let selected = selectedSetting else { return }

            let vc = segue.destination as? SettingsDetailViewController
            vc?.configure(with: selected.title,
                          textViewContent: selected == .licence ? .licence : .imprint)
        default:
            return
        }
    }
}

extension SettingsViewController {
    func reloadUsernameCell() {
        UIView.performWithoutAnimation {
            guard let rowForUsername = settings.firstIndex(of: SettingItem.name) else { return }
            let indexPath = IndexPath(row: rowForUsername, section: 0)
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }

    func importMovies() {
        let documentPickerVC = UIDocumentPickerViewController(
            documentTypes: [String.exportMoviesFileUTI],
            in: .import
        )
        documentPickerVC.delegate = self
        documentPickerVC.allowsMultipleSelection = false

        present(documentPickerVC, animated: true)
    }

    func exportMovies(showUIOn rect: CGRect) {
        guard let storageManager = storageManager else {
            fatalError("No storageManager injected")
        }

        let allMovies = storageManager.fetchAll()

        guard !allMovies.isEmpty else {
            //database is empty, inform user that an export is not useful
            showAlert(withMessage: Alert.exportEmptyData)
            return
        }

        do {
            try Exporter.saveAsFileToExport(allMovies)
        } catch {
            showAlert(withMessage: Alert.exportFailedInfo)
        }

        let path = URL(fileURLWithPath: Exporter.exportPath)
        docController = UIDocumentInteractionController(url: path)
        docController?.uti = String.exportMoviesFileUTI
        docController?.presentOptionsMenu(from: rect, in: view, animated: true)
    }
}

// MARK: - UITextFieldDelegate

extension SettingsViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        let entryLength = text.count + string.count - range.length
        UsernameAlert.saveAction?.isEnabled = entryLength > 0

        return true
    }
}

extension SettingsViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "SettingsViewController" }
}
