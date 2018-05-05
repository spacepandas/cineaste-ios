//
//  TextView.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

public class DescriptionTextView: UITextView {

    func setup(with contentBlocks: [ContentBlock]) {
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

        //Chain attributed string
        let contentChain = NSMutableAttributedString(string: "")

        for block in contentBlocks {
            if let title = block.title,
                !title.isEmpty {
                let titleBlock = "\(title)\n"
                contentChain.append(NSAttributedString(string: titleBlock))

                let range = NSRange(location: contentChain.length - titleBlock.count,
                                    length: titleBlock.count)
                contentChain.addAttributes(titleAttributes,
                                           range: range)
            }

            let paragraphBlock = "\(block.paragraph)\n\n"
            contentChain.append(NSAttributedString(string: paragraphBlock))

            let range = NSRange(location: contentChain.length - paragraphBlock.count,
                                length: paragraphBlock.count)
            contentChain.addAttributes(paragraphAttributes,
                                       range: range)
        }

        self.attributedText = contentChain
    }

}
