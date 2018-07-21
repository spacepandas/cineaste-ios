//
//  ImportMoviesViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 03.04.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class ImportMoviesViewController: UIViewController {
    @IBOutlet var importStateLabel: TitleLabel!
    @IBOutlet var importActivityIndicator: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        importStateLabel.text = String.importingMovies
        importActivityIndicator.color = UIColor.black
    }
}

extension ImportMoviesViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "ImportMoviesViewController" }
}
