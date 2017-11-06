//
//  MovieDetailViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 04.11.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class MovieDetailViewController: UIViewController {
    @IBOutlet weak fileprivate var seenButton: UIButton!
    @IBOutlet weak fileprivate var mustSeeButton: UIButton!
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
        descriptionTextView.isEditable = false
        styleButton(button: mustSeeButton)
        styleButton(button: seenButton)
    }

    func styleButton(button: UIButton) {
        button.layer.borderWidth = 1.0
        button.layer.borderColor = button.tintColor.cgColor
        button.layer.cornerRadius = 8
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }

    // MARK: - Actions

    @IBAction func mustSeeButtonTouched(_ sender: UIButton) {
        guard let movie = movie else { return }

        AppDelegate.persistentContainer.performBackgroundTask { context in
            _ = StoredMovie(withMovie: movie, context: context)
            try? context.save()
            DispatchQueue.main.async {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }

    @IBAction func seenButtonTouched(_ sender: UIButton) {
    }

}
