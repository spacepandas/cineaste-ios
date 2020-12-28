//
//  UIImageView+Loading.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.07.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit
import Kingfisher

private let cache = AppGroup.imageCache

extension UIImageView {

    /// This loads an image from a poster path in a specific size. If the
    /// poster path is nil, a placeholder image is set.
    ///
    /// To display that a poster is downloading, the UI is updated:
    /// - During download times an activity indicator is shown over the
    /// placeholder image.
    /// - If a smaller image is already in cache, the smaller image will be
    /// presented during the download.
    ///
    /// App Widgets can use the cache for the images as well, so the images
    /// don't have to be downloaded again.
    ///
    /// - Parameters:
    ///   - posterPath: The path to where to download the poster
    ///   - size: The size in which the image should be downloaded
    func loadingImage(from posterPath: String?, in size: Constants.PosterSize) {
        guard let posterPath = posterPath else {
            image = UIImage.posterPlaceholder
            return
        }

        kf.indicatorType = .activity

        // check if a poster with another size is already cached
        let cacheKey: String
        if size == .original {
            cacheKey = Movie.posterUrl(from: posterPath, for: .small)
                .absoluteString
        } else {
            cacheKey = Movie.posterUrl(from: posterPath, for: .original)
                .absoluteString
        }

        var cachedPoster: UIImage?

        // if another poster is already in cache, use this as placeholderImage
        if cache.isCached(forKey: cacheKey) {
            cache.retrieveImage(forKey: cacheKey) { result in
                guard case let .success(value) = result else { return }
                cachedPoster = value.image
            }
        }

        let posterUrl = Movie.posterUrl(from: posterPath, for: size)
        kf.setImage(
            with: posterUrl,
            placeholder: cachedPoster ?? UIImage.posterPlaceholder,
            options: [.targetCache(cache)]
        )
    }
}
