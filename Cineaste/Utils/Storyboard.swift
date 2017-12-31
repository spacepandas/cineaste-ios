//
//  Storyboard.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

enum Storyboard: String {
    case main = "Main"
    case search = "Search"
    case movieDetail = "MovieDetail"
}

extension Storyboard {
    func load() -> UIStoryboard {
        return UIStoryboard(name: self.rawValue, bundle: .main)
    }
}
