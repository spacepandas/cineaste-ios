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

    @IBOutlet var title: TitleLabel!

    func configure(with settingsItem: SettingItem) {
        title.text = settingsItem.title
    }

}
