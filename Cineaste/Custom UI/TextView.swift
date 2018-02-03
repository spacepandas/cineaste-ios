//
//  TextView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

public class DescriptionTextView: UITextView {
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // swiftlint:disable:next implicitly_unwrapped_optional
    override public var text: String! {
        didSet {
            setup()
        }
    }

    func setup() {
        let color = UIColor.basicBackground
        let font = UIFont.systemFont(ofSize: 16)
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 7

        let attributes = [NSAttributedStringKey.paragraphStyle: style,
                          NSAttributedStringKey.font: font,
                          NSAttributedStringKey.foregroundColor: color]
        self.attributedText = NSAttributedString(string: self.text,
                                                 attributes: attributes)
    }
}
