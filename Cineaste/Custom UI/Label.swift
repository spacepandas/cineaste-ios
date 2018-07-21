//
//  Label.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 27.12.17.
//  Copyright © 2017 notimeforthat.org. All rights reserved.
//

import UIKit

public class DescriptionLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        font = UIFont.systemFont(ofSize: 13.0)
        textColor = UIColor.accentText
    }
}

public class TitleLabel: UILabel {
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    func setup() {
        font = UIFont.systemFont(ofSize: 18.0)
        textColor = UIColor.black
    }
}
