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
    @IBOutlet weak var contentStackView: UIStackView!

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

        let contentSizeCategory = UIScreen.main.traitCollection.preferredContentSizeCategory

        if #available(iOS 11.0, *) {
            contentSizeCategory.isAccessibilityCategory
                ? updateToVerticalLayout()
                : updateToHorizontalLayout()
        } else {
            if contentSizeCategory == .accessibilityMedium
                || contentSizeCategory == .accessibilityLarge
                || contentSizeCategory == .accessibilityExtraLarge
                || contentSizeCategory == .accessibilityExtraExtraLarge
                || contentSizeCategory == .accessibilityExtraExtraExtraLarge {
                updateToVerticalLayout()
            } else {
                updateToHorizontalLayout()
            }
        }
    }

    private func updateToVerticalLayout() {
        contentStackView.axis = .vertical
        contentStackView.alignment = .leading
        numberOfMoviesLabel.textAlignment = .left
    }

    private func updateToHorizontalLayout() {
        contentStackView.axis = .horizontal
        contentStackView.alignment = .center
        numberOfMoviesLabel.textAlignment = .right
    }
}
