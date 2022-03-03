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

        blurredBackgroundImage.loadingImage(from: posterPath, in: .original)
        blurredBackgroundImage.addBlurEffect(with: .dark)

        imageView.loadingImage(from: posterPath, in: .original)
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
