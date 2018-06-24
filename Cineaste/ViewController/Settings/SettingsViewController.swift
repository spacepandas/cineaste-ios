//
//  SettingsViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import MessageUI

class SettingsViewController: UIViewController {
    @IBOutlet var settingsTableView: UITableView! {
        didSet {
            settingsTableView.dataSource = self
            settingsTableView.delegate = self
            settingsTableView.backgroundColor = UIColor.basicBackground
            settingsTableView.tableFooterView = footerView
        }
    }

    @IBOutlet var versionInfo: DescriptionLabel!
    @IBOutlet var footerView: UIView!

    var settings: [SettingItem] = [] {
        didSet {
            settingsTableView.reloadData()
        }
    }

    var selectedSetting: SettingItem?

    lazy var fetchedResultsManager = FetchedResultsManager()
    var docController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.settingsTitle

        view.backgroundColor = UIColor.basicBackground

        settings = SettingItem.all

        versionInfo?.text = versionString()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if UIApplication.shared.statusBarStyle != .lightContent {
            UIApplication.shared.statusBarStyle = .lightContent
        }
    }

    func versionString() -> String {
        guard
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return "" }
        var versionInformation = "\(String.versionText): \(version) (\(build))"

        #if DEBUG
        versionInformation.append(" || Dev")
        #endif

        return versionInformation
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        switch Segue(initWith: segue) {
        case .showTextViewFromSettings?:
            guard let selected = selectedSetting else { return }

            let vc = segue.destination as? SettingsDetailViewController
            vc?.title = selected.title
            vc?.textViewContent = (selected == SettingItem.licence)
                ? TextViewType.licence
                : TextViewType.imprint
        default:
            return
        }
    }

    // MARK: - Import and Export

    func prepareForImport(completionHandler handler: @escaping () -> Void) {
        setupFetchedResultManager()

        if let objects = fetchedResultsManager.controller?.fetchedObjects,
            !objects.isEmpty {
            //database is not empty, ask if user is sure to import new data
            showAlert(withMessage: Alert.askingForImport, defaultActionHandler: {
                handler()
            })
        } else {
            handler()
        }
    }

    func saveMoviesLocally(completionHandler handler: @escaping (URL) -> Void) {
        setupFetchedResultManager()

        guard let objects = fetchedResultsManager.controller?.fetchedObjects,
            !objects.isEmpty else {
                //database is empty, inform user that export is not useful
                showAlert(withMessage: Alert.exportEmptyData)
                return
        }

        fetchedResultsManager.exportMoviesList { result in
            switch result {
            case .error:
                DispatchQueue.main.async {
                    self.showAlert(withMessage: Alert.exportFailedInfo)
                    return
                }
            case .success:
                guard let path = self.fetchedResultsManager.exportMoviesPath
                    else { return }
                handler(path)
            }
        }
    }

    private func setupFetchedResultManager() {
        if fetchedResultsManager.controller == nil {
            fetchedResultsManager.setup(with: nil)
        } else {
            if fetchedResultsManager.controller?.fetchRequest.predicate != nil {
                fetchedResultsManager.refetch(for: nil)
            }
        }
    }

    private func showUIToImportMovies() {
        let documentPickerVC = UIDocumentPickerViewController(documentTypes: [String.exportMoviesFileUTI],
                                                              in: .import)
        documentPickerVC.delegate = self

        if #available(iOS 11.0, *) {
            documentPickerVC.allowsMultipleSelection = false
        }

        UIApplication.shared.statusBarStyle = .default
        present(documentPickerVC, animated: true, completion: nil)
    }

    private func showUIToExportMovies(with path: URL, on rect: CGRect) {
        docController = UIDocumentInteractionController(url: path)
        docController?.uti = String.exportMoviesFileUTI

        docController?.presentOptionsMenu(from: rect,
                                          in: self.view,
                                          animated: true)
    }
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: SettingsCell = tableView.dequeueCell(identifier: SettingsCell.identifier)

        if settings[indexPath.row].segue == nil {
            cell.accessoryType = .none
        } else {
            cell.accessoryType = .disclosureIndicator
        }

        cell.configure(with: settings[indexPath.row])

        return cell
    }
}

extension SettingsViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        selectedSetting = settings[indexPath.row]

        guard let setting = selectedSetting else { return }
        switch setting {
        case .about, .licence:
            guard let segue = setting.segue else { return }
            perform(segue: segue, sender: self)
        case .exportMovies:
            saveMoviesLocally { exportPath in
                DispatchQueue.main.async {
                    self.showUIToExportMovies(with: exportPath,
                                              on: tableView.rectForRow(at: indexPath))
                }
            }
        case .importMovies:
            prepareForImport {
                DispatchQueue.main.async {
                    self.showUIToImportMovies()
                }
            }
        case .contact:
            if MFMailComposeViewController.canSendMail() {
                let mailComposeVC = MFMailComposeViewController()
                mailComposeVC.mailComposeDelegate = self
                mailComposeVC.setSubject("Cineaste iOS || \(versionString())")
                mailComposeVC.setToRecipients(["ios@spacepandas.de"])

                present(mailComposeVC, animated: true, completion: nil)
            } else {
                showAlert(withMessage: Alert.noEmailClient)
            }
        }
    }
}

extension SettingsViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}

extension SettingsViewController: UIDocumentPickerDelegate {
    //selected json with movies to import
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentAt url: URL) {
        do {
            let data = try Data(contentsOf: url, options: [])

            //display simple UI when importing new data
            let importMoviesVC = ImportMoviesViewController.instantiate()
            self.present(importMoviesVC, animated: true) {
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
            self.showAlert(withMessage: Alert.importFailedCouldNotReadFile)
        }
    }
}

extension SettingsViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "SettingsViewController" }
}
