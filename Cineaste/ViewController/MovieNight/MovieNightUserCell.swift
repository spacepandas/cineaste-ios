//
//  MovieNightUserTableViewCell.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieNightUserCell: UITableViewCell {
    static let cellIdentifier = "MovieNightUserTableViewCell"

    @IBOutlet weak var usernameLabel: TitleLabel!
    @IBOutlet weak var numberOfMoviesLabel: DescriptionLabel!

    func configure(width nearbyMessage: NearbyMessage) {
        usernameLabel.text = nearbyMessage.userName
        numberOfMoviesLabel.text = Strings.nearbyMovies(for: nearbyMessage.movies.count)
    }
}
