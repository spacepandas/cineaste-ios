//
//  PosterViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 24.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController, UIScrollViewDelegate {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var blurredBackgroundImage: UIImageView!
    @IBOutlet var backgroundView: UIView!

    @IBOutlet var toolbar: UIToolbar! {
        didSet {
            toolbar.setBackgroundImage(UIImage(),
                                       forToolbarPosition: .any,
                                       barMetrics: .default)
            toolbar.backgroundColor = .clear
            toolbar.setShadowImage(UIImage(),
                                   forToolbarPosition: .any)
            toolbar.tintColor = .primaryOrange
        }
    }

    var image: UIImage?
    var posterPath: String?

    override func viewDidLoad() {
        super.viewDidLoad()

        backgroundView.backgroundColor = .transparentBlack
        backgroundView.addBlurEffect(with: .dark)

        blurredBackgroundImage.image = image
        blurredBackgroundImage.addBlurEffect(with: .dark)

        imageView.isUserInteractionEnabled = true

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2.0

        let gestureRecognizer = UITapGestureRecognizer(target: self,
                                                       action: #selector(handleDoubleTapScrollView(recognizer:)))
        gestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(gestureRecognizer)

        if let posterPath = posterPath {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: Movie.posterUrl(from: posterPath, for: .original),
                                  placeholder: image)
        } else {
            imageView.image = image
        }

    }

    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }

    @objc
    func handleDoubleTapScrollView(recognizer: UITapGestureRecognizer) {
        if scrollView.zoomScale == 1 {
            scrollView.zoom(to: zoomRectForScale(scale: scrollView.maximumZoomScale,
                                                 center: recognizer.location(in: recognizer.view)),
                            animated: true)
        } else {
            scrollView.setZoomScale(1, animated: true)
        }
    }

    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        let newCenter = imageView.convert(center, from: scrollView)
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }

    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension PosterViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "PosterViewController" }
}

extension UIView {
    func addBlurEffect(with style: UIBlurEffectStyle) {
        let blurEffect = UIBlurEffect(style: style)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = self.bounds

        // for supporting device rotation
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.addSubview(blurEffectView)
    }
}
