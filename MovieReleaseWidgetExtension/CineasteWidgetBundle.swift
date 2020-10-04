//
//  CineasteWidgetBundle.swift
//  MovieReleaseWidgetExtension
//
//  Created by Felizia Bernutz on 04.10.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import WidgetKit
import SwiftUI

@main
struct CineasteWidgetBundle: WidgetBundle {
    @WidgetBundleBuilder var body: some Widget {
        CountdownWidget()
        CountdownMinimalisticWidget()
    }
}
