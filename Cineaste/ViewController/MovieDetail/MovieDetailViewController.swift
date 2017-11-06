//
//  MovieDetailViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 04.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak fileprivate var posterImageView: UIImageView!
    @IBOutlet weak fileprivate var titleLabel: UILabel!
    @IBOutlet weak fileprivate var descriptionTextView: UITextView!

    var movie: Movie? {
        didSet {
            DispatchQueue.main.async {
                self.posterImageView.image = self.movie?.poster
                self.titleLabel.text = self.movie?.title
                self.descriptionTextView.text = self.movie?.overview
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        AppDelegate.persistentContainer.performBackgroundTask { context in
            let storedMovie = StoredMovie(context: context)
            storedMovie.id = self.movie?.id ?? 1
            storedMovie.title = self.movie?.title
            storedMovie.overview = self.movie?.overview
            storedMovie.posterPath = self.movie?.posterPath
            storedMovie.voteAverage = self.movie?.voteAverage ?? 0
            try? context.save()
        }

    }
}
