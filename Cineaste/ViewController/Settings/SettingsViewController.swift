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

    var settings: [SettingItem] = [SettingItem.about,
                                   SettingItem.licence,
                                   SettingItem.exportMovies,
                                   SettingItem.importMovies]

    var selectedSetting: SettingItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Einstellungen", comment: "Title for settings viewController")

        view.backgroundColor = UIColor.basicBackground

        versionInfo?.text = versionString()
    }

    func versionString() -> String {
        guard
            let version = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as? String,
            let build = Bundle.main.object(forInfoDictionaryKey: kCFBundleVersionKey as String) as? String
            else { return "" }
        let versionText = NSLocalizedString("Version", comment: "Description for app version")
        return "\(versionText): \(version) (\(build))"
    }

    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        guard let identifier = Segue(initWith: segue) else {
            fatalError("unable to use Segue enum")
        }

        guard let selected = selectedSetting else { return }

        switch identifier {
        case .showTextViewFromSettings:
            let vc = segue.destination as? ImprintViewController
            vc?.title = selected.title
            vc?.textViewContent =
                (selected == SettingItem.licence)
                ? TextViewContent.licence
                : TextViewContent.imprint
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
            let alert = UIAlertController(title: "Info", message: "Feature isn't implemented", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "Ok", style: .default, handler: nil)
            alert.addAction(okAction)
            present(alert, animated: true, completion: nil)
        }
    }
}

extension SettingsViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "SettingsViewController" }
}
