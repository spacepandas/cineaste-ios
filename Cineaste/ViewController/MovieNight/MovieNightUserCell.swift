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

    @IBOutlet private weak var allTitle: UILabel!
    @IBOutlet private weak var namesOfFriendsLabel: UILabel!
    @IBOutlet private weak var numberOfMoviesLabel: UILabel!

    func configureAll(numberOfMovies: Int, namesOfFriends: [String]) {
        setup()

        allTitle.text = String.allResultsForMovieNight
        numberOfMoviesLabel.text = String.movies(for: numberOfMovies)

        namesOfFriendsLabel.isHidden = false
        namesOfFriendsLabel.text = namesOfFriends.joined(separator: ", ")
    }

    func configure(userName: String, numberOfMovies: Int) {
        setup()

        allTitle.text = userName
        numberOfMoviesLabel.text = String.movies(for: numberOfMovies)

        namesOfFriendsLabel.isHidden = true
    }

    private func setup() {
        accessoryType = .disclosureIndicator
    }
}
