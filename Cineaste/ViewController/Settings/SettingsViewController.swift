//
//  SettingsViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsViewController: UITableViewController {

    var settings: [SettingItem] = [SettingItem.about,
                                   SettingItem.licence,
                                   SettingItem.exportMovies,
                                   SettingItem.importMovies]

    var selectedSetting: SettingItem?

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("Einstellungen", comment: "Title for settings viewController")

        view.backgroundColor = UIColor.basicBackground
        tableView.backgroundColor = UIColor.basicBackground
        tableView.tableFooterView = UIView()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return settings.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
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

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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

extension SettingsViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "SettingsViewController" }
}
