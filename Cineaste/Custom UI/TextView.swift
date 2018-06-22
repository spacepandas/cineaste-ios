//
//  TextView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

public class DescriptionTextView: UITextView {
    private let paragraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7
        return style
    }()

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    override public var text: String! {
        didSet {
            setup()

            let defaultAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                     NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                                     NSAttributedStringKey.foregroundColor: UIColor.basicBackground]

            self.attributedText = NSAttributedString(string: self.text,
                                                     attributes: defaultAttributes)
        }
    }

    func setup() {
        isEditable = false
        dataDetectorTypes = .link
        linkTextAttributes = [NSAttributedStringKey.foregroundColor.rawValue: UIColor.primaryOrange]
    }

    func setup(with type: TextViewType) {
        let titleAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                               NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18),
                               NSAttributedStringKey.foregroundColor: UIColor.basicBackground]

        let paragraphAttributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle,
                                   NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16),
                                   NSAttributedStringKey.foregroundColor: UIColor.accentText]

        let chain = type.chainContent(titleAttributes: titleAttributes,
                                      paragraphAttributes: paragraphAttributes)

        self.attributedText = chain
    }

}
