//
//  UIImageView+Loading.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 07.07.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func loadingImage(from posterPath: String?, in size: Constants.PosterSize) {
        guard let posterPath = posterPath else {
            image = UIImage.posterPlaceholder
            return
        }

        kf.indicatorType = .activity

        let posterUrl = Movie.posterUrl(from: posterPath, for: size)
        kf.setImage(with: posterUrl, placeholder: UIImage.posterPlaceholder)
    }
}
