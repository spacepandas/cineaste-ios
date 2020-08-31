//
//  CineasteWidget.swift
//  CineasteWidget
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI

//swiftlint:disable void_return
struct Provider: TimelineProvider {
    let storeUrl = AppGroup.widget.containerURL
        .appendingPathComponent("movies.json")

    public typealias Entry = SimpleEntry

    func placeholder(in context: Context) -> SimpleEntry {
        .previewData
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        var entry: SimpleEntry
        let moviesData = (try? Data(contentsOf: storeUrl)) ?? Data()
        if let decodedData = try? JSONDecoder().decode([Movie].self, from: moviesData) {
            entry = SimpleEntry(date: Date(), movies: decodedData)
        } else {
            entry = .previewData
        }
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entry: SimpleEntry
        let moviesData = (try? Data(contentsOf: storeUrl)) ?? Data()
        if let decodedData = try? JSONDecoder().decode([Movie].self, from: moviesData) {
            entry = SimpleEntry(date: Date(), movies: decodedData)
        } else {
            entry = .previewData
        }

        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let movies: [Movie]

    static let previewData = SimpleEntry(
        date: Date(),
        movies: [.testSeen, .testSeen, .testSeen]
    )
}

@main
struct CineasteWidget: Widget {
    let kind: String = "CineasteWidget"

    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: DynamicMovieSelectionIntent.self, provider: Provider()) { entry in
            WidgetView(entry: entry)
        }
        .configurationDisplayName("My Widget")
        .description("This is an example widget.")
        .supportedFamilies([.systemLarge, .systemMedium, .systemSmall])
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
