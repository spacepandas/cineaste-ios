//
//  UIFont+SymbolicTraits.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 03.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension UIFont {
    private func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

    func bold() -> UIFont {
        withTraits(traits: .traitBold)
    }

    func condensed() -> UIFont {
        withTraits(traits: .traitCondensed)
    }

    func italic() -> UIFont {
        withTraits(traits: .traitItalic)
    }
}
