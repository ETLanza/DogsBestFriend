//
//  SignUpViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/25/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class SignUpViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }
    
    // MARK: - IBActions
    
    @IBAction func cancelButtonTapped(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func signUpButtonTapped(_ sender: UIButton) {
        if usernameTextField.text == repeatPasswordTextField.text {
            guard let username = usernameTextField.text, !username.isEmpty,
                let password = passwordTextField.text, !password.isEmpty else {
                    let missingInfoAlert = AlertManager.displayAlertMessage(userMessage: "All fields must be filled out and the passwords must match")
                    present(missingInfoAlert, animated: true, completion: nil)
                    return
            }
            UserController.shared.signUp(username: username, password: password) { (success) in
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
                    let destinationVC = storyboard.instantiateInitialViewController()
                    self.present(destinationVC!, animated: true, completion: nil)
                }
            }
        } else {
            let matchingPasswordAlert = AlertManager.displayAlertMessage(userMessage: "Both password fields must match")
            present(matchingPasswordAlert, animated: true, completion: nil)
        }
    }
    
    // MARK: - Helper Methods
    
    func setUpViews() {
        signUpButton.layer.cornerRadius = 12
        signUpButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.masksToBounds = true
    }
}
