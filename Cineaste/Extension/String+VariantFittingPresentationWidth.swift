//
//  String+VariantFittingPresentationWidth.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 10.06.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

extension String {
    var forWidth: String {
        let width =
            Int(UIScreen.main.bounds.width) > 320
                ? 35
                : 1
        return (self as NSString).variantFittingPresentationWidth(width)
    }
}
