//
//  TextViewContent.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

enum TextViewContent {
    case imprint
    case licence

    var content: String {
        switch self {
        case .imprint:
            return Strings.imprintContent
        case .licence:
            return Strings.licenceContent
        }
    }
}
