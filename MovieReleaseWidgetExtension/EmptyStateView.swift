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
            Text("No upcoming movies in your Watchlist")
                .font(Font.custom("Noteworthy", fixedSize: 24))
                .bold()
                .minimumScaleFactor(0.01)
            Text("Search for a movie and add it to your Watchlist")
                .font(Font.custom("Noteworthy", fixedSize: 24))
                .minimumScaleFactor(0.01)
        }.padding()
        .widgetURL(URL(string: "widget-deeplink://search")!)
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
