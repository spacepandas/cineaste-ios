//
//  PosterViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 24.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {
    @IBOutlet var scrollView: UIScrollView!
    @IBOutlet var imageView: UIImageView!
    @IBOutlet var blurredBackgroundImage: UIImageView!

    var image: UIImage?
    var posterPath: String?

    var originalPosition: CGPoint?
    var currentPositionTouched: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        blurredBackgroundImage.image = image
        blurredBackgroundImage.addBlurEffect(with: .dark)

        imageView.isUserInteractionEnabled = true

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2.0

        let tapGestureRecognizer =
            UITapGestureRecognizer(target: self,
                                   action: #selector(handleDoubleTap(recognizer:)))
        tapGestureRecognizer.numberOfTapsRequired = 2
        scrollView.addGestureRecognizer(tapGestureRecognizer)

        let panGestureRecognizer =
            UIPanGestureRecognizer(target: self,
                                   action: #selector(handlePanGesture(recognizer:)))
        panGestureRecognizer.maximumNumberOfTouches = 1
        panGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(panGestureRecognizer)

        if let posterPath = posterPath {
            imageView.kf.indicatorType = .activity
            imageView.kf.setImage(with: Movie.posterUrl(from: posterPath,
                                                        for: .original),
                                  placeholder: image)
        } else {
            imageView.image = image
        }
    }

    @objc
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
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

    @objc
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        guard scrollView.zoomScale == 1 else { return }

        let translation = recognizer.translation(in: imageView)

        switch recognizer.state {
        case .began:
            originalPosition = imageView.center
            currentPositionTouched = recognizer.location(in: imageView)
        case .changed:
            imageView.frame.origin = CGPoint(x: translation.x,
                                             y: translation.y)

            let halfImageHeight = imageView.bounds.height / 2
            let alpha = abs(halfImageHeight - imageView.center.y) / halfImageHeight

            blurredBackgroundImage.alpha = 1 - alpha
        case .ended:
            let minimumVelocity = 1_500 as CGFloat
            let minimumScreenRatio = 0.5 as CGFloat
            let animationDuration = 0.2

            let velocity = recognizer.velocity(in: imageView)

            let isFastEnoughToDismiss = velocity.y > minimumVelocity
            let isLowEnoughToDismiss =
                translation.y > view.frame.size.height * minimumScreenRatio

            if isFastEnoughToDismiss || isLowEnoughToDismiss {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.imageView.frame.origin =
                        CGPoint(x: self.imageView.frame.origin.x,
                                y: self.imageView.frame.size.height)
                    self.blurredBackgroundImage.alpha = 0
                }, completion: { _ in
                    self.dismiss(animated: false)
                })
            } else {
                UIView.animate(withDuration: animationDuration) {
                    if let position = self.originalPosition {
                        self.imageView.center = position
                        self.blurredBackgroundImage.alpha = 1
                    }
                }
            }
        default:
            break
        }
    }
}

extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return imageView
    }
}

extension PosterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension PosterViewController: Instantiable {
    static var storyboard: Storyboard { return .movieDetail }
    static var storyboardID: String? { return "PosterViewController" }
}
