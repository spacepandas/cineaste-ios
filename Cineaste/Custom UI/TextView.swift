//
//  TextView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

public class DescriptionTextView: UITextView {

    func setup(with type: TextViewType) {
        isEditable = false
        dataDetectorTypes = .link
        linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.primaryOrange]

        //Define attributes
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        style.hyphenationFactor = 0.7

        let titleAttributes = [NSAttributedStringKey.paragraphStyle: style,
                               NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
                               NSAttributedStringKey.foregroundColor: UIColor.basicBackground]

        let paragraphAttributes = [NSAttributedStringKey.paragraphStyle: style,
                                   NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                                   NSAttributedStringKey.foregroundColor: UIColor.accentText]

        let chain = type.chainContent(titleAttributes: titleAttributes,
                               paragraphAttributes: paragraphAttributes)

        self.attributedText = chain
    }

}
