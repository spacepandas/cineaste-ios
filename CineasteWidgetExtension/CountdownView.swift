//
//  CountdownView.swift
//  CineasteWidgetExtension
//
//  Created by Felizia Bernutz on 31.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

struct CountdownView: View {
    var entry: SimpleEntry

    var difference: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: entry.movie.releaseDate ?? Date(), relativeTo: Date())
    }

    var body: some View {
        VStack {
            GeometryReader { proxy in
                entry.image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }
            Text(entry.movie.title)
            Text("In Theaters")
                .font(.caption)
            Text(difference)
                .multilineTextAlignment(.center)
                .font(.title2)
        }
    }
}

struct CountdownView_Previews: PreviewProvider {
    static var previews: some View {
        CountdownView(entry: .previewData)
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
    }
}
