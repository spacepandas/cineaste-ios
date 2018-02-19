//
//  MyMoviesCategory.swift
//  Cineaste
//
//  Created by Christian Braun on 28.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation
import UIKit

enum MovieListCategory: String {
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

    var image: UIImage {
        switch self {
        case .wantToSee:
            return Images.wantToSeeIcon
        case .seen:
            return Images.seenIcon
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
