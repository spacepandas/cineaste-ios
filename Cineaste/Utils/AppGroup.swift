//
//  AppGroup.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 23.08.20.
//  Copyright © 2020 spacepandas.de. All rights reserved.
//

import Foundation

public enum AppGroup: String {
    #if DEBUG
    case widget = "group.de.spacepandas.ios.cineaste-development"
    #else
    case widget = "group.de.spacepandas.ios.cineaste"
    #endif

    public var containerURL: URL {
        FileManager.default.containerURL(
            forSecurityApplicationGroupIdentifier: self.rawValue
        )! // swiftlint:disable:this force_unwrapping
    }
}
