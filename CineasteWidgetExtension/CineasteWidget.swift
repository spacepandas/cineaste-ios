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

    func image(forMovie movie: Movie, completion: @escaping (SwiftUI.Image) -> Void) {
        let placeholder = Image(uiImage: .posterPlaceholder)
        guard let posterPath = movie.posterPath else { return completion(placeholder) }

        let cacheKey = Movie.posterUrl(from: posterPath, for: .original)
            .absoluteString

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
            let url = Movie.posterUrl(from: posterPath, for: .original)
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

    func getSnapshot(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (CountdownEntry) -> Void) {
        guard let movie = movie(for: configuration) else {
            return completion(.previewData)
        }

        image(forMovie: movie) { image in
            let entry = CountdownEntry(
                date: Date(),
                movie: movie,
                image: image
            )
            completion(entry)
        }
    }

    func getTimeline(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (Timeline<CountdownEntry>) -> Void) {
        guard let movie = movie(for: configuration) else {
            let timeline = Timeline(entries: [CountdownEntry.previewData], policy: .atEnd)
            return completion(timeline)
        }

        image(forMovie: movie) { image in
            let entry = CountdownEntry(
                date: Date(),
                movie: movie,
                image: image
            )
            let timeline = Timeline(entries: [entry], policy: .atEnd)
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
