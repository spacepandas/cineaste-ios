//
//  CountdownView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 31.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

private struct TextHeightPreference: PreferenceKey {
    static var defaultValue: CGFloat = 0

    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value = max(value, nextValue())
    }
}

struct CountdownView: SwiftUI.View {
    var entry: CountdownEntry
    @Environment(\.colorScheme) var colorScheme
    private var outlineRadius: CGFloat {
        colorScheme == .dark ? 0.6 : 1.2
    }
    @State private var textHeight: CGFloat = 45

    var difference: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.day, .weekOfMonth]
        formatter.unitsStyle = .full
        formatter.maximumUnitCount = 1
        formatter.collapsesLargestUnit = true
        let releaseDate = entry.movie.releaseDate ?? Date()
        let formattedReleaseDate = formatter.string(from: Date(), to: releaseDate + 24 * 60 * 60) ?? ""

        return formattedReleaseDate
    }

    var body: some SwiftUI.View {
        GeometryReader { proxy in
            ZStack(alignment: .bottom) {
                entry.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .blur(radius: 1)
                    .frame(width: proxy.size.width, height: proxy.size.height)

                Color.background
                    .opacity(0.75)
                    .frame(height: textHeight)

                HStack(alignment: .bottom, spacing: 0) {
                    Text(difference.split(separator: " ")[0])
                        .font(Font.custom("Noteworthy", fixedSize: 500))
                        .bold()
                        .minimumScaleFactor(0.01)
                        .aspectRatio(contentMode: .fit)
                        .frame(width: proxy.size.width * 0.4)
                        .outlined(radius: outlineRadius)
                    VStack(alignment: .leading) {
                        Text(difference.split(separator: " ")[1].uppercased())
                            .font(Font.custom("Noteworthy", fixedSize: 24))
                            .bold()
                            .minimumScaleFactor(0.01)
                            .lineLimit(1)
                            .outlined(radius: outlineRadius)
                        Text(entry.movie.title)
                            .font(Font.custom("Noteworthy", fixedSize: 15))
                            .bold()
                            .minimumScaleFactor(0.01)
                            .lineLimit(2)
                            .multilineTextAlignment(.leading)
                            .padding([.bottom, .trailing], 7)
                            .background(GeometryReader {
                                Color.clear.preference(key: TextHeightPreference.self, value: $0.size.height)
                            })
                    }
                }
            }
        }
        .onPreferenceChange(TextHeightPreference.self) {
            textHeight = $0
        }
        .widgetURL(URL(string: "widget-deeplink://\(entry.movie.id)")!)
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some SwiftUI.View {
        Group {
            CountdownView(entry: .previewData)
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
            CountdownView(entry: .previewData)
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
                .environment(\.colorScheme, .dark)
        }
    }
}
