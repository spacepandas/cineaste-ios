//
//  DescriptionTextView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class DescriptionTextView: UITextView {
    private let paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        return style
    }()

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    override var text: String! {
        didSet {
            setup()

            let defaultAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
                NSAttributedString.Key.foregroundColor: UIColor.basicBackground
            ]

            attributedText = NSAttributedString(string: self.text,
                                                attributes: defaultAttributes)
        }
    }

    func setup() {
        isEditable = false
        dataDetectorTypes = .link
        linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.primaryOrange
        ]
    }

    func setup(with type: TextViewType) {
        let titleAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 18),
            NSAttributedString.Key.foregroundColor: UIColor.basicBackground
        ]

        let paragraphAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.accentTextOnWhite
        ]

        let chain = type.chainContent(titleAttributes: titleAttributes,
                                      paragraphAttributes: paragraphAttributes)

        attributedText = chain
    }

}
