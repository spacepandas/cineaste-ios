//
//  EmptyStateMinimalisticView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 20.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

struct EmptyStateMinimalisticView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("movie_release_widget_no_upcoming_movies")
                .font(.headline)
                .minimumScaleFactor(0.01)
            Text("movie_release_widget_search_and_add_movie")
                .font(.body)
                .minimumScaleFactor(0.01)
        }.padding()
        .background(Color.background)
        .widgetURL(WidgetURL.search)
    }
}

struct EmptyStateMinimalisticView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EmptyStateMinimalisticView()
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
            )
            EmptyStateMinimalisticView()
                .previewContext(
                    WidgetPreviewContext(family: .systemSmall)
                )
                .environment(\.colorScheme, .dark)
        }
    }
}
