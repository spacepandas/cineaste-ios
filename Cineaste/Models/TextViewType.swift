//
//  TextViewContent.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 11.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import Foundation

enum TextViewType {
    case imprint
    case licence

    var content: [ContentBlock] {
        switch self {
        case .imprint:
            return [ContentBlock(title: nil,
                                 paragraph: Strings.imprintContent)]
        case .licence:
            guard let url = Bundle.main.url(forResource: "Acknowledgements",
                                            withExtension: "plist",
                                            subdirectory: "Settings.bundle"),
                let dictionary = NSDictionary(contentsOf: url),
                let array = dictionary.object(forKey: "PreferenceSpecifiers")
                    as? [[String: String]]
                else {
                    print("Acknowledgements.plist in Settings.bundle not found or could not parse file")
                    return []
            }

            var contentArray = [ContentBlock]()

            for element in array {
                if let title = element["Title"],
                    let paragraph = element["FooterText"] {
                    contentArray.append(ContentBlock(title: title,
                                                     paragraph: paragraph))
                }
            }

            return contentArray
        }
    }

    func chainContent(titleAttributes: [NSAttributedStringKey: NSObject],
                      paragraphAttributes: [NSAttributedStringKey: NSObject]) -> NSMutableAttributedString {
        let chain = NSMutableAttributedString(string: "")
        for block in self.content {
            if let title = block.title,
                !title.isEmpty {
                let titleBlock = "\(title)\n"
                chain.append(NSAttributedString(string: titleBlock))

                let range = NSRange(location: chain.length - titleBlock.count,
                                    length: titleBlock.count)
                chain.addAttributes(titleAttributes,
                                           range: range)
            }

            let paragraphBlock = "\(block.paragraph)\n\n"
            chain.append(NSAttributedString(string: paragraphBlock))

            let range = NSRange(location: chain.length - paragraphBlock.count,
                                length: paragraphBlock.count)
            chain.addAttributes(paragraphAttributes,
                                       range: range)
        }
        return chain
    }
}
