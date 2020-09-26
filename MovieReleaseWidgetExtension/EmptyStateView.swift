//
//  EmptyStateView.swift
//  MovieReleaseWidgetExtension
//
//  Created by Xaver Lohmüller on 20.09.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import SwiftUI
import WidgetKit

struct EmptyStateView: View {
    var body: some View {
        VStack(alignment: .leading) {
            Text("movie_release_widget_no_upcoming_movies")
                .font(Font.custom("Noteworthy", fixedSize: 24))
                .bold()
                .minimumScaleFactor(0.01)
            Text("movie_release_widget_search_and_add_movie")
                .font(Font.custom("Noteworthy", fixedSize: 24))
                .minimumScaleFactor(0.01)
        }.padding()
        .widgetURL(WidgetURL.search)
    }
}

struct EmptyStateView_Previews: PreviewProvider {
    static var previews: some View {
        EmptyStateView()
            .previewContext(
                WidgetPreviewContext(family: .systemSmall)
            )
    }
}
