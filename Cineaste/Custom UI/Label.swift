//
//  Label.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

class Label: UILabel {
    func setup() {
        fatalError("Override this method in your subclass")
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }
}

class DescriptionLabel: Label {
    override func setup() {
        font = UIFont.preferredFont(forTextStyle: .subheadline)
        textColor = UIColor.basicBackground
        adjustsFontForContentSizeCategory = true
    }
}

class TitleLabel: Label {
    override func setup() {
        font = UIFont.preferredFont(forTextStyle: .headline)
        textColor = UIColor.basicBlack
        adjustsFontForContentSizeCategory = true
    }
}

class HeaderLabel: Label {
    override func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setCondensedSymbolicTrait),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil)

        setCondensedSymbolicTrait()

        textColor = UIColor.basicBlack
    }
}

class HintLabel: Label {
    override func setup() {
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setItalicSymbolicTrait),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil)

        setItalicSymbolicTrait()

        textColor = UIColor.basicBackground
    }
}

extension Label {
    @objc
    func setCondensedSymbolicTrait() {
        font = UIFont.preferredFont(forTextStyle: .title2).condensed()
    }

    @objc
    func setItalicSymbolicTrait() {
        font = UIFont.preferredFont(forTextStyle: .subheadline).italic()
    }
}
