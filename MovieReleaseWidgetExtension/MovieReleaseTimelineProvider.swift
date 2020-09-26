//
//  MovieReleaseTimelineProvider.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 12.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit

struct MovieReleaseTimelineProvider: IntentTimelineProvider {
    typealias Entry = CountdownEntry
    typealias Intent = DynamicMovieSelectionIntent

    func placeholder(in context: Context) -> CountdownEntry {
        .empty
    }

    func getSnapshot(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        guard let movie = movie(for: configuration) else {
            return completion(.empty)
        }

        movie.loadImage { image in
            let entry = CountdownEntry(
                date: Date(),
                content: .movie(movie: movie, image: image)
            )
            completion(entry)
        }
    }

    func getTimeline(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        guard let movie = movie(for: configuration) else {
            let timeline = Timeline<CountdownEntry>(entries: [.empty], policy: .atEnd)
            return completion(timeline)
        }

        movie.loadImage { image in
            let entry = CountdownEntry(
                date: Date(),
                content: .movie(movie: movie, image: image)
            )
            let timeline = Timeline(entries: [entry], policy: .atEnd)
            completion(timeline)
        }
    }

    private func movie(for configuration: DynamicMovieSelectionIntent) -> Movie? {
        let storeUrl = AppGroup.widget.containerURL
            .appendingPathComponent("movies.json")

        guard let moviesData = (try? Data(contentsOf: storeUrl)) ?? Data(),
              let movies = try? JSONDecoder().decode([Movie].self, from: moviesData)
                else { return nil }

        if let selectedMovieId = configuration.movie?.identifier {
            return movies.first { $0.id == Int(selectedMovieId) ?? 0 }
        } else {
            return movies.first(where: \.soonAvailable)
        }
    }
}
