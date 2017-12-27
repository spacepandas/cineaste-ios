//
//  Segue.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

extension UIViewController {
    func performSegue<T: RawRepresentable>(withIdentifier identifier: T, sender: AnyObject?) where T.RawValue == String {
        self.performSegue(withIdentifier: identifier.rawValue, sender: sender)
    }
}

enum Segue: String {
    case showMovieDetail = "ShowMovieDetailSegue"

    init?(initWith segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else { fatalError("Segue identifier not found.") }
        self.init(rawValue: identifier)
    }
}
