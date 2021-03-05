//
//  AppGroup+Kingfisher.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 20.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Kingfisher

extension AppGroup {
    public static var imageCache: ImageCache {
        // swiftlint:disable:next force_try
        try! ImageCache(name: "de.cineaste.poster", cacheDirectoryURL: AppGroup.widget.containerURL)
    }
}
