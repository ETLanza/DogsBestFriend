//
//  LoginnViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 4/10/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit
import FirebaseUI
import GoogleSignIn

class SignUpViewController: UIViewController {
    
    // MARK: - Properties
    var creatingAccount: Bool = false

    // MARK: - IBOutlets
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var repeatPasswordStackView: UIStackView!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var createAccountButton: MainButton!
    @IBOutlet weak var resetPasswordButton: MainButton!
    @IBOutlet weak var googleSignInButton: GIDSignInButton!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var coverView: UIView!
    
    // MARK: - Life Cycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        GIDSignIn.sharedInstance()?.signOut()
    }
    
    // MARK: - IBActions
    @IBAction func signInButtonTapped(_ sender: UIButton) {
        if creatingAccount {
            endCreatingAccount()
        } else {
            startActivityIndicator()
            guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty else {
                let alertController = AlertManager.displayAlertMessage(userMessage: "Missing email or password")
                self.present(alertController, animated: true, completion: nil)
                stopActivityIndicator()
                return
            }
            
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
                guard let strongSelf = self else { return }
                
                if let error = error {
                    let alertController = AlertManager.displayAlertMessage(userMessage: error.localizedDescription)
                    strongSelf.present(alertController, animated: true, completion: nil)
                    strongSelf.stopActivityIndicator()
                    return
                }
                
                guard let authResult = authResult else { return }
                
                DBFUserController.shared.checkIfDBFUserExistFor(user: authResult.user) { (rsUser) in
                    if rsUser != nil {
                        strongSelf.stopActivityIndicator()
                        strongSelf.presentTabBar()
                    } else {
                        let alertController = AlertManager.displayAlertMessage(userMessage: "Error signing in. Please try again.")
                        strongSelf.present(alertController, animated: true, completion: nil)
                        strongSelf.stopActivityIndicator()
                    }
                }
            }
        }
    }
    
    @IBAction func createAccountButtonTapped(_ sender: UIButton) {
        if !creatingAccount {
            beingCreatingAccount()
        } else {
            startActivityIndicator()
            guard let email = emailTextField.text, !email.isEmpty,
                let password = passwordTextField.text, !password.isEmpty,
                let confirmPassword = confirmPasswordTextField.text else {
                    let alertController = AlertManager.displayAlertMessage(userMessage: "Missing email or password")
                    self.present(alertController, animated: true, completion: nil)
                    self.stopActivityIndicator()
                    return
            }
            
            guard password == confirmPassword else {
                let alertController = AlertManager.displayAlertMessage(userMessage: "Passwords do not match")
                self.present(alertController, animated: true, completion: nil)
                self.stopActivityIndicator()
                return
            }
            
            Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                if let error = error {
                    let alertController = AlertManager.displayAlertMessage(userMessage: error.localizedDescription)
                    self.present(alertController, animated: true, completion: nil)
                    self.stopActivityIndicator()
                    return
                }
                
                guard let authResult = authResult else {
                    let alertController = AlertManager.displayAlertMessage(userMessage: "Error creating account. Please close the app and try again.")
                    self.present(alertController, animated: true, completion: nil)
                    self.stopActivityIndicator()
                    return
                }
                
                DBFUserController.shared.createNewUserFrom(firebase: authResult.user, completion: { (success) in
                    if success {
                        self.stopActivityIndicator()
                        self.presentTabBar()
                    }
                })
            }
        }
    }
    
    @IBAction func resetPasswordButtonTapped(_ sender: UIButton) {
        var resetEmailTextField = UITextField()
        let alertController = UIAlertController(title: "Reset Password", message: "Enter account email to send a password reset email", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter email..."
            textfield.keyboardType = .emailAddress
            textfield.text = self.emailTextField.text
            resetEmailTextField = textfield
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            guard let email = resetEmailTextField.text, !email.isEmpty else {
                let failedAlertController = AlertManager.displayAlertMessage(userMessage: "Must enter email address to reset password")
                self.present(failedAlertController, animated: true, completion: nil)
                return
            }
            
            self.startActivityIndicator()
            
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                if let error = error {
                    let failedAlertController = AlertManager.displayAlertMessage(userMessage: error.localizedDescription)
                    self.present(failedAlertController, animated: true, completion: nil)
                    self.stopActivityIndicator()
                    return
                }
                
                let completedAlertController = AlertManager.displayAlertMessage(userMessage: "Password reset instructions sent to \(email)")
                self.present(completedAlertController, animated: true, completion: nil)
                self.stopActivityIndicator()
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    // MARK: - Helper Methods
    func setUpViews() {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
        self.title = ""
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().delegate = self
        googleSignInButton.colorScheme = .light
        googleSignInButton.style = .wide
        addInputAccessoryForTextFields(textFields: [emailTextField, passwordTextField], dismissable: true, previousNextable: true)
        googleSignInButton.addTarget(self, action: #selector(startActivityIndicator), for: .touchDown)
    }
    
    @objc func keyboardWillShow(notification: NSNotification) {
        var userInfo = notification.userInfo!
        var keyboardFrame: CGRect = (userInfo[UIResponder.keyboardFrameBeginUserInfoKey] as! NSValue).cgRectValue
        keyboardFrame = self.view.convert(keyboardFrame, from: nil)
        
        var contentInset: UIEdgeInsets = self.scrollView.contentInset
        contentInset.bottom = keyboardFrame.size.height + 50
        scrollView.contentInset = contentInset
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        let contentInset = UIEdgeInsets.zero
        scrollView.contentInset = contentInset
    }
    
    func beingCreatingAccount() {
        hideKeyBoard()
        creatingAccount = true
        repeatPasswordStackView.isHidden = false
        signInButton.setTitle("Cancel", for: .normal)
        addInputAccessoryForTextFields(textFields: [emailTextField, passwordTextField, confirmPasswordTextField], dismissable: true, previousNextable: true)
    }
    
    func endCreatingAccount() {
        hideKeyBoard()
        creatingAccount = false
        repeatPasswordStackView.isHidden = true
        signInButton.setTitle("Sign In", for: .normal)
        addInputAccessoryForTextFields(textFields: [emailTextField, passwordTextField], dismissable: true, previousNextable: true)
    }
    
    @objc func startActivityIndicator() {
        DispatchQueue.main.async {
            self.signInButton.isEnabled = false
            self.resetPasswordButton.isEnabled = false
            self.createAccountButton.isEnabled = false
            self.coverView.isHidden = false
            self.activityIndicator.startAnimating()
        }
    }
    
    func stopActivityIndicator() {
        DispatchQueue.main.async {
            self.signInButton.isEnabled = true
            self.resetPasswordButton.isEnabled = true
            self.createAccountButton.isEnabled = true
            self.coverView.isHidden = true
            self.activityIndicator.stopAnimating()
        }
    }
    
    func hideKeyBoard() {
        emailTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        if !repeatPasswordStackView.isHidden {
            confirmPasswordTextField.resignFirstResponder()
        }
    }
    
    func presentTabBar() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = UIStoryboard(name: "TabBar", bundle: nil).instantiateInitialViewController()
        }
    }
}

extension SignUpViewController: GIDSignInDelegate, GIDSignInUIDelegate {
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error with Google Sign In: \(error) : \(error.localizedDescription)")
            return
        }
        
        GIDSignIn.sharedInstance()?.signOut()
        
        guard let authentication = user.authentication else { return }
        let credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken,
                                                       accessToken: authentication.accessToken)
        
        Auth.auth().signInAndRetrieveData(with: credential) { (authResult, error) in
            if let error = error {
                print("Error with Google Sign In Credential: \(error) : \(error.localizedDescription)")
                return
            }
            
            guard let authResult = authResult else { return }
            
            DBFUserController.shared.checkIfDBFUserExistFor(user: authResult.user) { (rsUser) in
                if rsUser != nil {
                    self.presentTabBar()
                } else {
                    DBFUserController.shared.createNewUserFrom(firebase: authResult.user) { (success) in
                        if success {
                            self.presentTabBar()
                        }
                    }
                }
            }
        }
    }
}
