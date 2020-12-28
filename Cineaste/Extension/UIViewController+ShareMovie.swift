//
//  UIViewController+ShareMovie.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension UIViewController {
    /// This presents an `UIActivityViewController` to share a movie.
    /// - Parameters:
    ///   - movie: The movie which should be shared.
    ///   - barButtonItem: The barButtonItem where the `UIActivityViewController`
    ///   should be presented on (for iPads).
    func share(movie: Movie, onBarButtonItem barButtonItem: UIBarButtonItem) {
        let activityController = getConfiguredActivityVC(for: movie)
        activityController.popoverPresentationController?.barButtonItem = barButtonItem

        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }
    }

    /// This presents an `UIActivityViewController` to share a movie. 
    /// - Parameters:
    ///   - movie: The movie which should be shared.
    ///   - sourceView: The source view where the `UIActivityViewController`
    ///   should be presented on (for iPads).
    func share(movie: Movie, onSourceView sourceView: UIView) {
        let activityController = getConfiguredActivityVC(for: movie)

        activityController.popoverPresentationController?.sourceView = sourceView
        activityController.popoverPresentationController?.sourceRect = CGRect(
            x: sourceView.bounds.midX,
            y: sourceView.bounds.midY,
            width: 0,
            height: 0
        )

        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }
    }

    private func getConfiguredActivityVC(for movie: Movie) -> UIActivityViewController {
        var items = [Any]()

        items.append(movie.title)

        if let url = Constants.Backend.shareUrl(for: movie) {
            items.append(url)
        }

        return UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
    }
}
