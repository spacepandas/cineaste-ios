//
//  SpotlightIndexing.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 16.12.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import CoreSpotlight
import MobileCoreServices

enum SpotlightIndexing {
    static func indexItems(_ movies: Set<Movie>) {
        var items: [CSSearchableItem] = []

        for movie in movies {
            let attributeSet = CSSearchableItemAttributeSet(
                itemContentType: kUTTypeText as String
            )
            attributeSet.title = movie.title
            attributeSet.contentDescription = movie.overview

            let item = CSSearchableItem(
                uniqueIdentifier: "\(movie.id)",
                domainIdentifier: "de.spacepandas",
                attributeSet: attributeSet
            )
            items.append(item)
        }

        CSSearchableIndex.default().indexSearchableItems(items)
    }

    static func deindexItem(_ movie: Movie) {
        CSSearchableIndex.default().deleteSearchableItems(withIdentifiers: ["\(movie.id)"])
    }
}
