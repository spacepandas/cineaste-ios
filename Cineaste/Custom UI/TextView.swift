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
        backgroundColor = .clear
        isEditable = false
        isSelectable = true
        dataDetectorTypes = .link
        linkTextAttributes = [
            NSAttributedString.Key.foregroundColor: UIColor.cineLink
        ]

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setDynamicType),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil)
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

    @objc
    func setDynamicType() {
        setAttributes()
    }
}

class DescriptionTextView: TextView {
    var type: TextViewType? {
        didSet {
            setAttributes()
        }
    }

    override func setAttributes() {
        if let type = type {
            let titleAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .headline),
                NSAttributedString.Key.foregroundColor: UIColor.cineTitle
            ]

            let paragraphAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                NSAttributedString.Key.foregroundColor: UIColor.cineDescription
            ]

            attributedText = type
                .chainContent(titleAttributes: titleAttributes,
                              paragraphAttributes: paragraphAttributes)
        } else {
            let defaultAttributes = [
                NSAttributedString.Key.paragraphStyle: paragraphStyle,
                NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .body),
                NSAttributedString.Key.foregroundColor: UIColor.cineDescription
            ]

            attributedText = NSAttributedString(string: text,
                                                attributes: defaultAttributes)
        }
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
            NSAttributedString.Key.font: UIFont.preferredFont(forTextStyle: .subheadline),
            NSAttributedString.Key.foregroundColor: UIColor.cineFooter
        ]

        attributedText = NSAttributedString(string: text,
                                            attributes: defaultAttributes)
    }
}
