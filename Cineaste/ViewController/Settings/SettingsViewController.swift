//
//  SettingsViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {
    @IBOutlet var footerView: UIView!
    @IBOutlet var versionInfo: DescriptionLabel! {
        didSet {
            versionInfo.textColor = .accentTextOnBlack
        }
    }

    let settings = SettingItem.allCases
    var selectedSetting: SettingItem?

    lazy var fetchedResultsManager = FetchedResultsManager()
    var docController: UIDocumentInteractionController?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = String.settingsTitle

        tableView.backgroundColor = UIColor.basicBackground
        tableView.tableFooterView = footerView

        versionInfo?.text = versionString()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if let indexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }

    func versionString() -> String {
        guard
            let version = Bundle.main
                .object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main
                .object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
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
            vc?.textViewContent =
                selected == SettingItem.licence
                ? TextViewType.licence
                : TextViewType.imprint
        default:
            return
        }
    }

    // MARK: - Import and Export

    func prepareForImport(completionHandler handler: @escaping () -> Void) {
        fetchedResultsManager.refetch()

        if fetchedResultsManager.movies.isEmpty {
            handler()
        } else {
            //database is not empty, ask if user is sure to import new data
            showAlert(withMessage: Alert.askingForImport, defaultActionHandler: {
                handler()
            })
        }
    }

    func saveMoviesLocally(completionHandler handler: @escaping (URL) -> Void) {
        fetchedResultsManager.refetch()

        guard !fetchedResultsManager.movies.isEmpty else {
            //database is empty, inform user that an export is not useful
            showAlert(withMessage: Alert.exportEmptyData)
            return
        }

        do {
            try fetchedResultsManager.exportMoviesList()
            guard let path = fetchedResultsManager.exportMoviesPath
                else { return }
            handler(URL(fileURLWithPath: path))
        } catch {
            showAlert(withMessage: Alert.exportFailedInfo)
        }
    }

    func showUIToImportMovies() {
        let documentPickerVC = UIDocumentPickerViewController(documentTypes: [String.exportMoviesFileUTI],
                                                              in: .import)
        documentPickerVC.delegate = self

        if #available(iOS 11.0, *) {
            documentPickerVC.allowsMultipleSelection = false
        }

        present(documentPickerVC, animated: true, completion: nil)
    }

    func showUIToExportMovies(with path: URL, on rect: CGRect) {
        docController = UIDocumentInteractionController(url: path)
        docController?.uti = String.exportMoviesFileUTI

        docController?.presentOptionsMenu(from: rect,
                                          in: self.view,
                                          animated: true)
    }
}

extension SettingsViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "SettingsViewController" }
}
