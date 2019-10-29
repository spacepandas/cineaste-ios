//
//  SearchController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 14.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SearchController: UISearchController {
    override init(searchResultsController: UIViewController?) {
        super.init(searchResultsController: searchResultsController)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }

    func setup() {
        obscuresBackgroundDuringPresentation = false
        isActive = false
        searchBar.sizeToFit()

        searchBar.smartQuotesType = .no

        if #available(iOS 13.0, *) {
            let searchField = searchBar.searchTextField
            searchField.backgroundColor = .cineSearchBackground
            searchField.layer.cornerRadius = 10
            searchField.clipsToBounds = true
        } else {
            guard let textfield = searchBar.value(forKey: "searchField") as? UITextField,
                let backgroundview = textfield.subviews.first
                else { return }
            backgroundview.backgroundColor = .cineSearchBackground
            backgroundview.layer.cornerRadius = 10
            backgroundview.clipsToBounds = true
        }
    }

}
