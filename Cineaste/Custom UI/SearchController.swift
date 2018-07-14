//
//  SearchController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

public class SearchController: UISearchController {
    public override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)

        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func setup() {
        obscuresBackgroundDuringPresentation = false
        isActive = false
        searchBar.sizeToFit()

        if #available(iOS 11.0, *) {
            guard let textfield = searchBar.value(forKey: "searchField") as? UITextField,
                let backgroundview = textfield.subviews.first else { return }
            backgroundview.backgroundColor = .basicWhite
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        }
    }

}
