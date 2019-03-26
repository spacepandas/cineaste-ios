//
//  Button.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class Button: UIButton {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        fatalError("Override this method in your subclass")
    }
}

class ActionButton: Button {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        super.setTitle(title?.uppercased(), for: state)
    }

    override func setup() {
        setTitleColor(UIColor.primaryDarkOrange, for: .normal)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setBoldSymbolicTrait),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil)

        // TODO: fix layout issues when using dynamic size, related to #80
        // https://github.com/spacepandas/cineaste-ios/issues/80
//        titleLabel?.adjustsFontForContentSizeCategory = true
//        titleLabel?.numberOfLines = 0
//        titleLabel?.lineBreakMode = .byWordWrapping
//        titleLabel?.textAlignment = .left

        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.2

        setBoldSymbolicTrait()
    }
}

class LinkButton: Button {
    override func setTitle(_ title: String?, for state: UIControl.State) {
        guard let title = title else { return }

        super.setTitle("▶︎ " + title, for: state)
    }

    override func setup() {
        setTitleColor(UIColor.primaryOrange, for: .normal)
        setTitleColor(UIColor.primaryOrange, for: .highlighted)

        NotificationCenter.default.addObserver(
            self,
            selector: #selector(setBoldSymbolicTrait),
            name: UIContentSizeCategory.didChangeNotification,
            object: nil)

        setBoldSymbolicTrait()

        titleLabel?.adjustsFontSizeToFitWidth = true
        titleLabel?.minimumScaleFactor = 0.2
    }
}

class BorderedButton: Button {

    override func setup() {
        tintColor = .primaryOrange

        contentEdgeInsets.top = 10
        contentEdgeInsets.bottom = 10
        contentEdgeInsets.left = 20
        contentEdgeInsets.right = 20

        layer.borderColor = UIColor.primaryOrange.cgColor
        layer.borderWidth = 2
        layer.cornerRadius = 4

        titleLabel?.adjustsFontSizeToFitWidth = true
    }
}

extension Button {
    @objc
    func setBoldSymbolicTrait() {
        titleLabel?.font = UIFont.preferredFont(forTextStyle: .callout).bold()
    }
}
