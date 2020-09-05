//
//  CineasteWidget.swift
//  CineasteWidget
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI
import Kingfisher

private let cache = try! ImageCache(name: "de.cineaste.poster", cacheDirectoryURL: AppGroup.widget.containerURL)

struct Provider: IntentTimelineProvider {
    typealias Entry = CountdownEntry
    typealias Intent = DynamicMovieSelectionIntent

    func placeholder(in context: Context) -> CountdownEntry {
        .previewData
    }

    func image(forKey key: String, completion: @escaping (SwiftUI.Image) -> Void) {
        if cache.isCached(forKey: key) {
            cache.retrieveImage(forKey: key) { result in
                switch result {
                case .success(let value):
                    completion(Image(uiImage: value.image ?? .posterPlaceholder))
                case .failure:
                    completion(Image(uiImage: .posterPlaceholder))
                }
            }
        }
    }

    func getSnapshot(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        if let movie = movie(for: configuration) {
            if let posterPath = movie.posterPath {

                let cacheKey = Movie.posterUrl(from: posterPath, for: .original)
                    .absoluteString
                image(forKey: cacheKey) { image in
                    let entry = CountdownEntry(
                        date: Date(),
                        movie: movie,
                        image: image
                    )
                    completion(entry)
                }
            } else {
                let entry = CountdownEntry(
                    date: Date(),
                    movie: movie,
                    image: Image(uiImage: .posterPlaceholder)
                )
                completion(entry)
            }
        } else {
            completion(.previewData)
        }
    }

    func getTimeline(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        if let movie = movie(for: configuration) {
            if let posterPath = movie.posterPath {

                let cacheKey = Movie.posterUrl(from: posterPath, for: .original)
                    .absoluteString
                image(forKey: cacheKey) { image in
                    let entry = CountdownEntry(
                        date: Date(),
                        movie: movie,
                        image: image
                    )

                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                }
            } else {
                let entry = CountdownEntry(
                    date: Date(),
                    movie: movie,
                    image: Image(uiImage: .posterPlaceholder)
                )

                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        } else {
            let timeline = Timeline(entries: [CountdownEntry.previewData], policy: .atEnd)
            completion(timeline)
        }
    }

    private func movie(for configuration: DynamicMovieSelectionIntent) -> Movie? {
        let storeUrl = AppGroup.widget.containerURL
            .appendingPathComponent("movies.json")
        let moviesData = (try? Data(contentsOf: storeUrl)) ?? Data()
        if let movies = try? JSONDecoder().decode([Movie].self, from: moviesData),
           let selectedMovieId = configuration.movie?.identifier,
           let movie = movies.first(where: { $0.id == Int(selectedMovieId) ?? 0 }) {
            return movie
        } else {
            return nil
        }
    }
}

@main
struct CineasteWidget: Widget {
    let kind: String = "CineasteWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(
            kind: kind,
            intent: DynamicMovieSelectionIntent.self,
            provider: Provider()
        ) { entry in
            CountdownView(entry: entry)
        }
        .configurationDisplayName("Show Countdown")
        .description("Count days until your favorite movie is in theaters")
        .supportedFamilies([.systemSmall])
    }
}

//struct CineasteWidget_Previews: PreviewProvider {
//    static var previews: some View {
//        WidgetView(entry: .previewData)
//        .previewContext(
//            WidgetPreviewContext(family: .systemSmall)
//        )
//    }
//}
