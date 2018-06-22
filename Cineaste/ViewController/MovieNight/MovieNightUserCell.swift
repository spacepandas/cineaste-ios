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

    @IBOutlet weak var usernameLabel: TitleLabel!
    @IBOutlet weak var numberOfMoviesLabel: DescriptionLabel!

    func configure(with nearbyMessage: NearbyMessage) {
        usernameLabel.text = nearbyMessage.userName
        numberOfMoviesLabel.text = String.movies(for: nearbyMessage.movies.count)
    }
}
