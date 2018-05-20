//
//  ImprintViewController.swift
//  Cineaste
//
//  Created by Felizia Bernutz on 07.01.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit
import SafariServices

class SettingsDetailViewController: UIViewController {
    @IBOutlet var settingsDetailTextView: DescriptionTextView! {
        didSet {
            settingsDetailTextView.delegate = self
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

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        UIApplication.shared.statusBarStyle = .lightContent
    }

    override func viewDidLayoutSubviews() {
        //scroll textview to top
        settingsDetailTextView.setContentOffset(CGPoint(x: 0, y: 0),
                                                animated: false)
    }

    private func update(_ type: TextViewType) {
        guard let textView = settingsDetailTextView else { return }

        textView.setup(with: type)
    }

}

extension SettingsDetailViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {

        let viewController = SFSafariViewController(url: URL)
        UIApplication.shared.statusBarStyle = .default
        present(viewController, animated: true, completion: nil)

        return false
    }
}

extension SettingsDetailViewController: Instantiable {
    static var storyboard: Storyboard { return .settings }
    static var storyboardID: String? { return "ImprintViewController" }
}
