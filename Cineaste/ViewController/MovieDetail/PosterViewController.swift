//
//  PosterViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 24.05.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class PosterViewController: UIViewController {
    @IBOutlet private weak var scrollView: UIScrollView!
    @IBOutlet private weak var imageView: UIImageView!
    @IBOutlet private weak var blurredBackgroundImage: UIImageView!
    @IBOutlet private weak var backgroundView: UIView!
    @IBOutlet private weak var toolbarBackgroundView: UIView!
    @IBOutlet private weak var toolbar: UIToolbar!

    private var posterPath: String?
    private var originalPosition: CGPoint?

    override func viewDidLoad() {
        super.viewDidLoad()

        configureElements()
        addGestureRecognizer()
    }

    func configure(with posterPath: String) {
        self.posterPath = posterPath
    }

    // MARK: IBAction

    @IBAction func doneButtonTouched(_ sender: UIBarButtonItem) {
        dismiss(animated: true)
    }

    @objc
    func handleOneTap(recognizer: UITapGestureRecognizer) {
        backgroundView.isHidden.toggle()
    }

    @objc
    func handleDoubleTap(recognizer: UITapGestureRecognizer) {
        guard scrollView.zoomScale == 1 else {
            scrollView.setZoomScale(1, animated: true)
            return
        }

        scrollView.zoom(
            to: zoomRectForScale(
                scale: scrollView.maximumZoomScale,
                center: recognizer.location(in: recognizer.view)
            ),
            animated: true
        )
    }

    @objc
    func handlePanGesture(recognizer: UIPanGestureRecognizer) {
        guard scrollView.zoomScale == 1 else { return }

        let translation = recognizer.translation(in: imageView)

        switch recognizer.state {
        case .began:
            originalPosition = imageView.center
        case .changed:
            imageView.frame.origin = CGPoint(x: 0, y: translation.y)

            let halfImageHeight = imageView.bounds.height / 2
            let alpha = abs(halfImageHeight - imageView.center.y) / halfImageHeight
            blurredBackgroundImage.alpha = 1 - alpha
            backgroundView.alpha = 1 - alpha
        case .ended:
            let minimumVelocity = 1_500 as CGFloat
            let minimumScreenRatio = 0.1 as CGFloat
            let animationDuration = 0.2

            let velocity = recognizer.velocity(in: imageView)

            let isFastEnoughToDismiss = velocity.y > minimumVelocity
            let isMovedEnoughToDismiss =
                abs(translation.y) > view.frame.size.height * minimumScreenRatio

            if isFastEnoughToDismiss || isMovedEnoughToDismiss {
                UIView.animate(withDuration: animationDuration, animations: {
                    self.imageView.frame.origin = CGPoint(
                        x: self.imageView.frame.origin.x,
                        y: self.imageView.frame.size.height
                    )
                    self.blurredBackgroundImage.alpha = 0
                    self.backgroundView.alpha = 0
                }, completion: { _ in
                    self.dismiss(animated: false)
                }) // swiftlint:disable:this multiline_arguments_brackets
            } else {
                guard let position = originalPosition else { return }

                UIView.animate(withDuration: animationDuration) {
                    self.imageView.center = position
                    self.blurredBackgroundImage.alpha = 1
                    self.backgroundView.alpha = 1
                }
            }
        default:
            break
        }
    }

    // MARK: Custom Functions

    private func configureElements() {
        toolbar.setBackgroundImage(
            UIImage(),
            forToolbarPosition: .any,
            barMetrics: .default
        )
        toolbar.backgroundColor = .clear
        toolbar.setShadowImage(
            UIImage(),
            forToolbarPosition: .any
        )

        toolbarBackgroundView.backgroundColor = .cineToolBarBackground
        toolbarBackgroundView.addBlurEffect(with: .dark)

        if let posterPath = posterPath {
            blurredBackgroundImage.kf.setImage(
                with: Movie.posterUrl(
                    from: posterPath,
                    for: .original
                )
            )
            imageView.kf.setImage(
                with: Movie.posterUrl(
                    from: posterPath,
                    for: .original
                )
            )
        }
        blurredBackgroundImage.addBlurEffect(with: .dark)

        imageView.accessibilityIgnoresInvertColors = true
        imageView.isUserInteractionEnabled = true

        scrollView.delegate = self
        scrollView.minimumZoomScale = 1
        scrollView.maximumZoomScale = 2.0
    }

    private func addGestureRecognizer() {
        let oneTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleOneTap(recognizer:))
        )
        oneTapGestureRecognizer.numberOfTapsRequired = 1
        oneTapGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(oneTapGestureRecognizer)

        let doubleTapGestureRecognizer = UITapGestureRecognizer(
            target: self,
            action: #selector(handleDoubleTap(recognizer:))
        )
        doubleTapGestureRecognizer.numberOfTapsRequired = 2
        doubleTapGestureRecognizer.delegate = self
        scrollView.addGestureRecognizer(doubleTapGestureRecognizer)

        if #available(iOS 13.0, *) {} else {
            let panGestureRecognizer = UIPanGestureRecognizer(
                target: self,
                action: #selector(handlePanGesture(recognizer:))
            )
            panGestureRecognizer.maximumNumberOfTouches = 1
            panGestureRecognizer.delegate = self
            scrollView.addGestureRecognizer(panGestureRecognizer)
        }
    }

    private func zoomRectForScale(scale: CGFloat, center: CGPoint) -> CGRect {
        let newCenter = imageView.convert(center, from: scrollView)

        var zoomRect = CGRect.zero
        zoomRect.size.height = imageView.frame.size.height / scale
        zoomRect.size.width = imageView.frame.size.width / scale
        zoomRect.origin.x = newCenter.x - (zoomRect.size.width / 2.0)
        zoomRect.origin.y = newCenter.y - (zoomRect.size.height / 2.0)
        return zoomRect
    }
}

extension PosterViewController: UIScrollViewDelegate {
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        imageView
    }
}

extension PosterViewController: UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        true
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRequireFailureOf otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Don't recognize a single tap until a double-tap fails.
        if (gestureRecognizer as? UITapGestureRecognizer)?.numberOfTapsRequired == 1
            && (otherGestureRecognizer as? UITapGestureRecognizer)?.numberOfTapsRequired == 2 {
            return true
        }
        return false
    }
}

extension PosterViewController: Instantiable {
    static var storyboard: Storyboard { .movieDetail }
    static var storyboardID: String? { "PosterViewController" }
}
