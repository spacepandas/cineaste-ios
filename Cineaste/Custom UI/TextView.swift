//
//  TextView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class TextView: UITextView {
    var paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        return style
    }()

    func setup() {
        isEditable = false
        dataDetectorTypes = .link
        linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.primaryOrange
        ]
    }

    func setAttributes() {
        fatalError("Override this method in your subclass")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    override var text: String! {
        didSet {
            setup()
            setAttributes()
        }
    }
}

class DescriptionTextView: TextView {

    override func setAttributes() {
        let defaultAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.basicBackground
        ]

        attributedText = NSAttributedString(string: self.text,
                                            attributes: defaultAttributes)
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

class LinkTextView: TextView {

    override func setup() {
        super.setup()

        isScrollEnabled = false
        backgroundColor = .clear
        textContainerInset = UIEdgeInsets.zero
        textContainer.lineFragmentPadding = 0
    }

    override func setAttributes() {
        let defaultAttributes = [
            NSAttributedString.Key.paragraphStyle: paragraphStyle,
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .footnote),
            NSAttributedString.Key.foregroundColor: UIColor.accentTextOnBlack
        ]

        attributedText = NSAttributedString(string: self.text,
                                            attributes: defaultAttributes)
    }
}
