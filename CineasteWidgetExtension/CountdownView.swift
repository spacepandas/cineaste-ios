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
    var movie: Movie
    var image: UIImage

    var difference: String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .full
        return formatter.localizedString(for: movie.releaseDate ?? Date(), relativeTo: Date())
    }

    var body: some View {
        VStack {
            GeometryReader { proxy in
                Image(uiImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: proxy.size.width, height: proxy.size.height)
                    .clipped()
            }
            Text(movie.title)
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
        CountdownView(movie: .testSeen, image: .posterPlaceholder)
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
    }
}