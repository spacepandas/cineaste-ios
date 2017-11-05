//
//  MovieDetailViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 04.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descriptionTextView: UITextView!
    
    var movie:Movie? {
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
        let storedMovie = StoredMovie(context: AppDelegate.viewContext)
        storedMovie.id = movie?.id ?? 1
        storedMovie.title = movie?.title
        storedMovie.overview = movie?.overview
        storedMovie.posterPath = movie?.posterPath
        storedMovie.voteAverage = movie?.voteAverage ?? 0
        
        try? AppDelegate.viewContext.save()
    }
}
