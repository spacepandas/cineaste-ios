//
//  MovieNightUserTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightUserCell: UITableViewCell {
    static let identifier = "MovieNightUserTableViewCell"

    @IBOutlet private weak var allTitle: TitleLabel!
    @IBOutlet private weak var namesOfFriendsLabel: DescriptionLabel!
    @IBOutlet private weak var numberOfMoviesLabel: DescriptionLabel!

    func configureAll(numberOfMovies: Int, namesOfFriends: [String]) {
        setup()

        //TODO: localize, and use Σ ?
        allTitle.text = "Alle"
        //TODO: localize
        numberOfMoviesLabel.text = "\(numberOfMovies) Filme"

        namesOfFriendsLabel.isHidden = false
        namesOfFriendsLabel.text = namesOfFriends.joined(separator: ", ")
    }

    func configure(userName: String, numberOfMovies: Int) {
        setup()

        allTitle.text = userName
        //TODO: localize
        numberOfMoviesLabel.text = "\(numberOfMovies) Filme"
        namesOfFriendsLabel.isHidden = true
    }

    private func setup() {
        accessoryType = .disclosureIndicator
    }
}
