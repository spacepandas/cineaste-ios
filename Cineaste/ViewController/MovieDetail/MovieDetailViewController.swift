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
                self.descriptionTextView.text = self.movie?.shortDescription
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}
