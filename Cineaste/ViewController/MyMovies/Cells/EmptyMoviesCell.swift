//
//  EmptyMoviesCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class EmptyMoviesCell: UITableViewCell {
    static let identifier = "EmptyMoviesCell"

    @IBOutlet var emptyListDescription: UILabel! {
        didSet {
            emptyListDescription.textColor = .basicWhite
        }
    }

    var category: MyMovieListCategory = .wantToSee {
        didSet {
            emptyListDescription.text = NSLocalizedString("Du hast noch keine Filme auf deiner \(category.tabBarTitle). Füge doch einen neuen Titel hinzu.", comment: "Description for empty movie list")
        }
    }
}
