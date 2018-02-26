//
//  Segue.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

enum Segue: String {
    case showMovieDetail = "ShowMovieDetailSegue"
    case showSearchFromMovieList = "ShowSearchFromMovieList"
    case showTextViewFromSettings = "showTextViewFromSettingsSegue"
    case showMovieNight = "ShowMovieNightSegue"
    case showUsername = "ShowUsernameSegue"
    case showMovieMatches = "ShowMovieMatchesSegue"

    init?(initWith segue: UIStoryboardSegue) {
        guard let identifier = segue.identifier else { fatalError("Segue identifier not found.") }
        self.init(rawValue: identifier)
    }
}

extension UIViewController {
    func perform(segue: Segue, sender: AnyObject?) {
        self.performSegue(withIdentifier: segue.rawValue, sender: sender)
    }
}
