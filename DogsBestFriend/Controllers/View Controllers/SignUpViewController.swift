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
        
    }
    
    // MARK: - Helper Methods
    
    func setUpViews() {
        signUpButton.layer.cornerRadius = 12
        signUpButton.layer.masksToBounds = true
        cancelButton.layer.cornerRadius = 12
        cancelButton.layer.masksToBounds = true
    }
}
