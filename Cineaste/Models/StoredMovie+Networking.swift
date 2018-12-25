//
//  StoredMovie+Networking.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.07.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import Kingfisher

extension StoredMovie {
    static func posterUrl(from posterPath: String, for size: Constants.PosterSize) -> URL {
        let urlAsString = "\(size.address)\(posterPath)?api_key=\(ApiKeyStore.theMovieDbKey)"
        guard let url = URL(string: urlAsString) else {
            fatalError("Could not create url for poster download")
        }
        return url
    }

    func loadPoster(completionHandler completion: @escaping (_ poster: Data?) -> Void) {
        guard let posterPath = posterPath else {
            completion(nil)
            return
        }

        let posterUrl = Movie.posterUrl(from: posterPath, for: .small)
        ImageDownloader.default.downloadImage(with: posterUrl) { result in
            completion(result.value?.originalData)
        }
    }
}
