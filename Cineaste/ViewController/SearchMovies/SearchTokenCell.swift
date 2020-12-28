//
//  SearchTokenCell.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 19.01.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import UIKit

class SearchTokenCell: UITableViewCell {
    static let identifier = "SearchTokenCell"

    @IBOutlet weak var tokenIcon: UIImageView!
    @IBOutlet weak var title: UILabel!

    func configure() {
        tokenIcon.image = UIImage.searchIcon
        title.text = "Horror"
    }

}
