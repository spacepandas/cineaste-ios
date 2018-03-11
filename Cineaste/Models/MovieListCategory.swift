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
            return Strings.wantToSeeList
        case .seen:
            return Strings.seenList
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

    var predicate: NSPredicate {
        switch self {
        case .wantToSee:
            return NSPredicate(format: "watched == %@", NSNumber(value: false))
        case .seen:
            return NSPredicate(format: "watched == %@", NSNumber(value: true))
        }
    }
}
