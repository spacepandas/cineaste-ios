//
//  UIFont+SymbolicTraits.swift
//  Cineaste App
//
//  Created by Felizia Bernutz on 03.03.19.
//  Copyright © 2019 spacepandas.de. All rights reserved.
//

import UIKit

extension UIFont {

    /// Create a new font with bold letters.
    ///
    /// This uses `UIFontDescriptor.SymbolicTraits` to modify the font style.
    /// - Returns: The new bold font
    func bold() -> UIFont {
        withTraits(traits: .traitBold)
    }

    /// Create a new font with condensed letters.
    ///
    /// This uses `UIFontDescriptor.SymbolicTraits` to modify the font style.
    /// - Returns: The new condensed font
    func condensed() -> UIFont {
        withTraits(traits: .traitCondensed)
    }

    /// Create a new font with italic letters.
    ///
    /// This uses `UIFontDescriptor.SymbolicTraits` to modify the font style.
    /// - Returns: The new italic font
    func italic() -> UIFont {
        withTraits(traits: .traitItalic)
    }

    private func withTraits(traits: UIFontDescriptor.SymbolicTraits) -> UIFont {
        guard let descriptor = fontDescriptor.withSymbolicTraits(traits) else {
            return self
        }
        return UIFont(descriptor: descriptor, size: 0)
    }

}
