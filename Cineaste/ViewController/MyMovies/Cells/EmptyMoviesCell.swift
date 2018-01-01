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

enum MyMovieListCategory: String {
    case wantToSee
    case seen

    var title: String {
        switch self {
        case .wantToSee:
            return NSLocalizedString("Musst du sehen", comment: "Title for want to see movie list")
        case .seen:
            return NSLocalizedString("Schon gesehen", comment: "Title for seen movie list")
        }
    }

    var tabBarTitle: String {
        switch self {
        case .wantToSee:
            return NSLocalizedString("Watch-List", comment: "TabBar title for want to see movie list")
        case .seen:
            return NSLocalizedString("Watched-List", comment: "TabBar title for seen movie list")
        }
    }

    var predicate: NSPredicate {
        switch self {
        case .wantToSee:
            return NSPredicate(format: "watched == %@", NSNumber(value: false))
        case .seen:
            return NSPredicate(format: "watched == %@", NSNumber(value: true))
        }
    }
}
