//
//  Movie+ImageLoading.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 12.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import Kingfisher

private let cache = try! ImageCache(name: "de.cineaste.poster", cacheDirectoryURL: AppGroup.widget.containerURL)

extension Movie {
    func loadImage(completion: @escaping (SwiftUI.Image) -> Void) {
        let placeholder = Image(uiImage: .posterPlaceholder)
        guard let posterPath = posterPath else { return completion(placeholder) }

        let url = Movie.posterUrl(from: posterPath, for: .original)
        let cacheKey = url.absoluteString

        if cache.isCached(forKey: cacheKey) {
            cache.retrieveImage(forKey: cacheKey) { result in
                switch result {
                case .success(let value):
                    completion(Image(uiImage: value.image ?? .posterPlaceholder))
                case .failure:
                    completion(placeholder)
                }
            }
        } else {
            ImageDownloader.default.downloadImage(with: url, options: [.targetCache(cache)], completionHandler: { result in
                switch result {
                case .success(let value):
                    completion(Image(uiImage: value.image))
                case .failure:
                    completion(placeholder)
                }
            })
        }
    }
}
