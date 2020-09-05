//
//  CineasteWidget.swift
//  CineasteWidget
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI

struct Provider: IntentTimelineProvider {
    typealias Entry = SimpleEntry
    typealias Intent = DynamicMovieSelectionIntent

    func placeholder(in context: Context) -> SimpleEntry {
        .previewData
    }

    func getSnapshot(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (SimpleEntry) -> Void) {
        var entry: SimpleEntry
        if let movie = movie(for: configuration) {
            entry = SimpleEntry(
                date: Date(),
                movie: movie,
                // TODO: load poster
                image: Image(uiImage: .posterPlaceholder)
            )
        } else {
            entry = .previewData
        }
        completion(entry)
    }

    func getTimeline(for configuration: DynamicMovieSelectionIntent, in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> Void) {
        var entry: SimpleEntry
        if let movie = movie(for: configuration) {
            entry = SimpleEntry(
                date: Date(),
                movie: movie,
                // TODO: load poster
                image: Image(uiImage: .posterPlaceholder)
            )
        } else {
            entry = .previewData
        }

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
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

struct SimpleEntry: TimelineEntry {
    let date: Date
    let movie: Movie
    let image: Image

    static let previewData = SimpleEntry(
        date: Date(),
        movie: .testSeen,
        image: Image(uiImage: .posterPlaceholder)
    )
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
