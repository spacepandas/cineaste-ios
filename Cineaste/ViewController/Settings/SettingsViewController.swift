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
            settingsTableView.tableFooterView = UIView()
        }
    }

    @IBOutlet var versionInfo: DescriptionLabel!

    var settings: [SettingItem] = [] {
        didSet {
            settingsTableView.reloadData()
        }
    }

    var selectedSetting: SettingItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = Strings.settingsTitle

        view.backgroundColor = UIColor.basicBackground

        settings = [SettingItem.about,
                    SettingItem.licence,
                    SettingItem.exportMovies,
                    SettingItem.importMovies]

        versionInfo?.text = versionString()
    }

    func versionString() -> String {
        guard
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return "" }
        return "\(Strings.versionText): \(version) (\(build))"
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
}

extension SettingsViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: SettingsCell.identifier, for: indexPath) as? SettingsCell else {
            fatalError("Unable to dequeue cell for identifier: \(SettingsCell.identifier)")
        }

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

        if let segue = selectedSetting?.segue {
            perform(segue: segue, sender: self)
        } else {
            showAlert(withMessage: Alert.missingFeatureInfo)
        }
    }
}

extension SettingsViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "SettingsViewController" }
}
