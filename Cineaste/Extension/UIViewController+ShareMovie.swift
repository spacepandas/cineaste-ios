//
//  UIViewController+ShareMovie.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension UIViewController {
    func share(movie: Movie, onBarButtonItem barButtonItem: UIBarButtonItem) {
        let activityController = sharingActivityViewController(for: movie)
        activityController.popoverPresentationController?.barButtonItem = barButtonItem

        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }
    }

    func share(movie: Movie, onSourceView sourceView: UIView) {
        let activityController = sharingActivityViewController(for: movie)

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

    private func sharingActivityViewController(for movie: Movie) -> UIActivityViewController {
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
