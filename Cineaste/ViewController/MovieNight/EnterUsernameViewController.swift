//
//  EnterUsernameViewController.swift
//  Cineaste
//
//  Created by Christian Braun on 21.02.18.
//  Copyright © 2018 notimeforthat.org. All rights reserved.
//

import UIKit

class EnterUsernameViewController: UIViewController {

    @IBOutlet fileprivate weak var headingLabel: UILabel!
    @IBOutlet fileprivate weak var descriptionLabel: UILabel!
    @IBOutlet fileprivate weak var usernameTextField: UITextField!
    @IBOutlet fileprivate weak var saveButton: UIButton!
    @IBOutlet fileprivate weak var cancelButton: UIButton!

    override func viewDidLoad() {
        super.viewDidLoad()
        headingLabel.text = NSLocalizedString("Enter a username", comment: "Enter username heading")
        descriptionLabel.text = NSLocalizedString("How do you want to appear on your friends", comment: "Enter username description")
        saveButton.setTitle(NSLocalizedString("Save", comment: "Enter username save button"), for: .normal)
        cancelButton.setTitle(NSLocalizedString("Cancel", comment: "Enter username cancel button"), for: .normal)
    }

    // MARK: - Actions
    @IBAction func saveButtonTouched(_ sender: Any) {
        guard let username = usernameTextField.text, !username.isEmpty else {
            return
        }

        UserDefaultsManager.setUsername(username)
        DispatchQueue.main.async {
            self.dismiss(animated: true, completion: nil)
        }
    }
}
