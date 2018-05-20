//
//  SettingsDetailViewControllerTests.swift
//  CineasteTests
//
//  Created by Felizia Bernutz on 19.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import XCTest
@testable import Cineaste

class SettingsDetailViewControllerTests: XCTestCase {
    let settingsDetailVC = SettingsDetailViewController.instantiate()
    
    func testTextViewShouldDisplayCorrectContent() {
        let titleAttributes = [NSAttributedStringKey.font: UIFont.boldSystemFont(ofSize: 18)]
        let paragraphAttributes = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 16)]
        
        //IMPRINT
        settingsDetailVC.textViewContent = .imprint
        XCTAssertNotNil(settingsDetailVC.settingsDetailTextView.attributedText)
        
        let imprintChain = TextViewType.imprint.chainContent(titleAttributes: titleAttributes,
                                                             paragraphAttributes: paragraphAttributes)
        XCTAssertEqual(settingsDetailVC.settingsDetailTextView.text, imprintChain.string)
        
        //LICENSE
        settingsDetailVC.textViewContent = .licence
        XCTAssertNotNil(settingsDetailVC.settingsDetailTextView.attributedText)
        
        let licenseChain = TextViewType.licence.chainContent(titleAttributes: titleAttributes,
                                                             paragraphAttributes: paragraphAttributes)
        XCTAssertEqual(settingsDetailVC.settingsDetailTextView.text, licenseChain.string)
    }
    
}
