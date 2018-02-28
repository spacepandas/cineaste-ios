//
//  ImprintViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class SettingsDetailViewController: UIViewController {
    @IBOutlet var settingsDetailTextView: UITextView! {
        didSet {
            update(textViewContent)
        }
    }

    var textViewContent: TextViewType = .imprint {
        didSet {
            if oldValue != textViewContent {
                update(textViewContent)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

    }

    private func update(_ type: TextViewType) {
        guard let textView = settingsDetailTextView else { return }
        textView.text = type.content
    }

}

extension SettingsDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "ImprintViewController" }
}
