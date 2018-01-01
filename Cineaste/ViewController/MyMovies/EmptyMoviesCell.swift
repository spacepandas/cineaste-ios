//
//  EmptyMoviesCell.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 01.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class EmptyMoviesCell: UITableViewCell {
    @IBOutlet var emptyListDescription: UILabel! {
        didSet {
            emptyListDescription.textColor = .basicWhite
        }
    }

    var category: MyMovieListCategory = .wantToSee {
        didSet {
            emptyListDescription.text = NSLocalizedString("Du hast noch keine Filme auf deiner \(category.name). Füge doch einen neuen Titel hinzu.", comment: "Description for empty movie list")
        }
    }

    static let identifier = "EmptyMoviesCell"
}

enum MyMovieListCategory: String {
    case wantToSee
    case seen

    var name: String {
        switch self {
        case .wantToSee:
            return NSLocalizedString("Watch-List", comment: "Name for want to see movie list")
        case .seen:
            return NSLocalizedString("Watched-List", comment: "Name for seen movie list")
        }
    }
}
