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
    func reloadPosterIfNeeded(completion: @escaping () -> Void) {
        guard poster == nil, let posterPath = posterPath else {
            completion()
            return
        }

        let url = Movie.posterUrl(from: posterPath, for: .small)
        let task = URLSession.shared.dataTask(with: url) { data, _, _ in
            self.poster = data
            completion()
        }
        task.resume()
    }
}
