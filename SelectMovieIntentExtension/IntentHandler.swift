//
//  IntentHandler.swift
//  SelectMovieIntent
//
//  Created by Felizia Bernutz on 31.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Intents

@available(iOSApplicationExtension 14.0, *)
class IntentHandler: INExtension, DynamicMovieSelectionIntentHandling {

    func provideMovieOptionsCollection(for intent: DynamicMovieSelectionIntent, with completion: @escaping (INObjectCollection<MovieIntent>?, Error?) -> Void) {

        let storeUrl = AppGroup.widget.containerURL
            .appendingPathComponent("movies.json")
        let moviesData = (try? Data(contentsOf: storeUrl)) ?? Data()
        if let movies = try? JSONDecoder().decode([Movie].self, from: moviesData) {
            let movieIntents = movies
                .filter(\.soonAvailable)
                .filter { $0.currentWatchState == .watchlist }
                .map { MovieIntent(identifier: "\($0.id)", display: $0.title) }
            let collection = INObjectCollection(items: movieIntents)
            completion(collection, nil)
        } else {
            completion(nil, nil)
        }
    }

    override func handler(for intent: INIntent) -> Any {
        self
    }
}
