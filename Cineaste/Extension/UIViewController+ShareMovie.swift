//
//  UIViewController+ShareMovie.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 17.11.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension UIViewController {
    func share(movie: Movie) {
        var items = [Any]()

        items.append(movie.title)

        if let url = Constants.Backend.shareUrl(for: movie) {
            items.append(url)
        }

        let activityController = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil)

        DispatchQueue.main.async {
            self.present(activityController, animated: true)
        }
    }
}
