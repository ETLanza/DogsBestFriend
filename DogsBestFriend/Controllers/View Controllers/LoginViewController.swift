//
//  LoginViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    // MARK: - IBOutlets
    
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var loginButton: UIButton!
    
    // MARK: - Life Cycle Methods

    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
    }

    // MARK: - IBActions

    @IBAction func loginButtonTapped(_ sender: UIButton) {
        guard let username = usernameTextField.text, !username.isEmpty,
            let password = passwordTextField.text, !password.isEmpty else {
                let missingInfoAlert = AlertManager.displayAlertMessage(userMessage: "Username and password fields must be filled out")
                present(missingInfoAlert, animated: true, completion: nil)
                return
        }
        UserController.shared.login(username: username, password: password) { (success) in
            if success {
                DispatchQueue.main.async {
                    let storyboard = UIStoryboard(name: "Onboard", bundle: nil)
                    let destinationVC = storyboard.instantiateInitialViewController()
                    self.present(destinationVC!, animated: true, completion: nil)
                }
            } else {
                DispatchQueue.main.async {
                    let wrongInfoAlert = AlertManager.displayAlertMessage(userMessage: "Either username or password is incorrect")
                    self.present(wrongInfoAlert, animated: true, completion: nil)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func setUpViews() {
        signUpButton.layer.cornerRadius = 12
        signUpButton.layer.masksToBounds = true
        loginButton.layer.cornerRadius = 12
        loginButton.layer.masksToBounds = true
    }
}
