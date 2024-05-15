//
//  SettingsCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsCell: UITableViewCell {
    static let identifier = "SettingsCell"

    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!

    func configure(with settingsItem: SettingItem) {
        backgroundColor = .cineCellBackground
        title.text = settingsItem.title

        accessoryType = settingsItem.segue == nil
            ? .none
            : .disclosureIndicator

        if let description = settingsItem.description {
            descriptionLabel.isHidden = false
            descriptionLabel.text = description
        } else {
            descriptionLabel.isHidden = true
        }
        accessibilityTraits.insert(.button)
    }

}
