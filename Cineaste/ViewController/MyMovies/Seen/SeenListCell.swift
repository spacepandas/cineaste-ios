//
//  SeenListCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 06.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class SeenListCell: UITableViewCell {
    static let identifier = "SeenListCell"

    @IBOutlet var title: UILabel!

    func configure(with movie: StoredMovie) {
        title.text = movie.title
    }
}
