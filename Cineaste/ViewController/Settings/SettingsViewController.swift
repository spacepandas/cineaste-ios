//
//  SettingsViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet var settingsTableView: UITableView! {
        didSet {
            settingsTableView.dataSource = self
            settingsTableView.delegate = self
            settingsTableView.backgroundColor = UIColor.basicBackground
            settingsTableView.tableFooterView = footerView
        }
    }

    @IBOutlet var versionInfo: DescriptionLabel! {
        didSet {
            versionInfo.textColor = .accentTextOnBlack
        }
    }
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

        if let indexPath = settingsTableView.indexPathForSelectedRow {
            settingsTableView.deselectRow(at: indexPath, animated: true)
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
