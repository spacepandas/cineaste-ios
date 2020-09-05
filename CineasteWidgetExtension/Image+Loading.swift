//
//  Image+Loading.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI

//extension Image {
//    func loadingImage(from posterPath: String?, in size: Constants.PosterSize) {
//        guard let posterPath = posterPath else {
//            image = UIImage.posterPlaceholder
//            return
//        }
//
//        kf.indicatorType = .activity
//
//        // check if a poster with another size is already cached
//        let cacheKey: String
//        if size == .original {
//            cacheKey = Movie.posterUrl(from: posterPath, for: .small)
//                .absoluteString
//        } else {
//            cacheKey = Movie.posterUrl(from: posterPath, for: .original)
//                .absoluteString
//        }
//
//        var cachedPoster: UIImage?
//
//        let cache = ImageCache.default
//
//        // if another poster is already in cache, use this as placeholderImage
//        if cache.isCached(forKey: cacheKey) {
//            cache.retrieveImage(forKey: cacheKey) { result in
//                guard case let .success(value) = result else { return }
//                cachedPoster = value.image
//            }
//        }
//
//        let posterUrl = Movie.posterUrl(from: posterPath, for: size)
//        kf.setImage(with: posterUrl, placeholder: cachedPoster ?? UIImage.posterPlaceholder)
//    }
//}
