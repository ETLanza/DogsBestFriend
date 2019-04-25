//
//  SettingsViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 4/25/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI
import GoogleSignIn

class SettingsViewController: UIViewController {
    
    // MARK: - IBOutlets
    
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var changeUsernameButton: MainButton!
    @IBOutlet weak var changeEmailButton: MainButton!
    @IBOutlet weak var resetPasswordButton: MainButton!
    @IBOutlet weak var signOutButton: MainButton!
    @IBOutlet weak var deleteAccountButton: MainButton!
    
    // MARK: - Properties
    
    var user = Auth.auth().currentUser!
    var credential: AuthCredential?
    var dbfUser = DBFUserController.shared.loggedInUser!
    let provider = Auth.auth().currentUser!.providerData.first!.providerID
    
    // MARK: - Life Cycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpViews()
        
        GIDSignIn.sharedInstance().clientID = FirebaseApp.app()?.options.clientID
        GIDSignIn.sharedInstance().delegate = self
        GIDSignIn.sharedInstance()?.uiDelegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        dbfUser = DBFUserController.shared.loggedInUser!
        user = Auth.auth().currentUser!
    }
    
    // MARK: - IBActions
    
    @IBAction func changeUsernameButtonTapped(_ sender: MainButton) {
        changeUsername { (success, needsReauth) in
            if success {
                DispatchQueue.main.async {
                    self.user = Auth.auth().currentUser!
                    self.usernameLabel.text = self.user.displayName
                }
            }
        }
    }
    
    @IBAction func changeEmailButtonTapped(_ sender: MainButton) {
        
        var emailTextField = UITextField()
        var repeatEmailTextField = UITextField()
        
        let alertController = UIAlertController(title: "Change Email Address", message: "Enter your new email address.", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter email address..."
            textField.keyboardType = .emailAddress
            emailTextField = textField
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Repeart email address..."
            textField.keyboardType = .emailAddress
            repeatEmailTextField = textField
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Change", style: .default, handler: { (_) in
            guard let email = emailTextField.text, !email.isEmpty,
                let repeatedEmail = repeatEmailTextField.text, !repeatedEmail.isEmpty else {
                    let failedAlertController = AlertManager.displayAlertMessage(userMessage: "Both Email fields must be filled out")
                    self.present(failedAlertController, animated: true, completion: nil)
                    return
            }
            
            guard email == repeatedEmail else {
                let failedAlertController = AlertManager.displayAlertMessage(userMessage: "Both Emails must match")
                self.present(failedAlertController, animated: true, completion: nil)
                return
            }
            
            self.turnOnActivityIndicator()
            self.changeUsersEmailAddress(to: email, completion: { (success, needsReauth) in
                if needsReauth {
                    self.reauthenticatePasswordUser(message: "change email") { (success) in
                        if success {
                            self.changeUsersEmailAddress(to: email, completion: { (success, needsReauth) in
                                if needsReauth {
                                    let failedAlertController = AlertManager.displayAlertMessage(userMessage: "Please try again")
                                    self.present(failedAlertController, animated: true, completion: nil)
                                    self.turnOffActivityIndicator()
                                    return
                                }
                                
                                if success {
                                    self.turnOffActivityIndicator()
                                    DispatchQueue.main.async {
                                        self.user = Auth.auth().currentUser!
                                        self.emailLabel.text = self.user.email
                                    }
                                }
                            })
                        } else {
                            self.turnOffActivityIndicator()
                        }
                    }
                }
                if success {
                    DispatchQueue.main.async {
                        self.turnOffActivityIndicator()
                        self.user = Auth.auth().currentUser!
                        self.emailLabel.text = self.user.email
                    }
                }
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func resetButtonTapped(_ sender: MainButton) {
        let alertController = UIAlertController(title: "Reset Password?", message: "Are you sure you want to reset your password?", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Reset", style: .default, handler: { (_) in
            guard let email = self.user.email else {
                let failedAlertController = AlertManager.displayAlertMessage(userMessage: "Email adddress invalid, please sign out and try again.")
                self.present(failedAlertController, animated: true, completion: nil)
                return
            }
            Auth.auth().sendPasswordReset(withEmail: email, completion: { (error) in
                if let error = error {
                    let failedAlertController = AlertManager.displayAlertMessage(userMessage: error.localizedDescription)
                    self.present(failedAlertController, animated: true, completion: nil)
                    return
                }
                
                let completedAlertController = AlertManager.displayAlertMessage(userMessage: "Password reset email has been sent to \(email)")
                self.present(completedAlertController, animated: true, completion: nil)
            })
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    
    @IBAction func logOutButtonTapped(_ sender: MainButton) {
        let alerController = UIAlertController(title: "Sign Out?", message: "Are you sure you want to sign out?", preferredStyle: .alert)
        
        alerController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alerController.addAction(UIAlertAction(title: "Sign Out", style: .default, handler: { (_) in
            do {
                try Auth.auth().signOut()
                self.popToSplashScreen()
            } catch {
                print("Error signing out : \(error) : \(error.localizedDescription)")
                return
            }
        }))
        
        self.present(alerController, animated: true, completion: nil)
    }
    
    @IBAction func deleteAccountButtonTapped(_ sender: MainButton) {
        deleteAccount { (success, needsReauth) in
            if success {
                try? Auth.auth().signOut()
                self.popToSplashScreen()
            }
            
            if needsReauth {
                if self.provider == "password" {
                    self.reauthenticatePasswordUser(message: "delete", completion: { (success) in
                        if success {
                            self.turnOffActivityIndicator()
                        }
                    })
                } else if self.provider == "google.com" {
                    self.signInGoogleUser(message: "delete account")
                    
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    
    func reauthenticatePasswordUser(message: String, completion: @escaping (Bool) -> Void) {
        var emailTextField: UITextField!
        var passwordTextField: UITextField!
        let alertController = UIAlertController(title: "Sign In", message: "Please sign in again to \(message)", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter Email..."
            textfield.keyboardType = .emailAddress
            emailTextField = textfield
        }
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter Password..."
            textfield.isSecureTextEntry = true
            passwordTextField = textfield
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (_) in
            completion(false)
        }))
        
        alertController.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (_) in
            guard let email = emailTextField.text, !email.isEmpty, let password = passwordTextField.text, !password.isEmpty
                else {
                    self.presentMissingInfoAlert()
                    completion(false)
                    return
            }
            
            self.turnOnActivityIndicator()
            
            Auth.auth().signIn(withEmail: email, password: password) { [weak self] user, error in
                guard let strongSelf = self else { return }
                if let error = error {
                    print("\(error) : \(error.localizedDescription)")
                    let incorrectDataAlertController = UIAlertController(title: "Login data incorrect", message: nil, preferredStyle: .alert)
                    
                    incorrectDataAlertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                    
                    strongSelf.present(incorrectDataAlertController, animated: true)
                    completion(false)
                    return
                }
                
                strongSelf.credential = EmailAuthProvider.credential(withEmail: email, password: password)
                
                
                strongSelf.user.reauthenticateAndRetrieveData(with: strongSelf.credential!, completion: { (authDataResult, error) in
                    if let error = error {
                        print("\(error) : \(error.localizedDescription)")
                        completion(false)
                        return
                    } else {
                        completion(true)
                    }
                })
            }
        }))
        self.present(alertController, animated: true)
    }
    
    func reauthenticateGoogleUser(completion: @escaping (Bool) -> Void) {
        if credential != nil {
            self.user.reauthenticateAndRetrieveData(with: credential!) { (authDataResult, error) in
                if let error = error {
                    print("\(error) : \(error.localizedDescription)")
                    completion(true)
                    return
                } else {
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
    
    func signInGoogleUser(message: String) {
        let alertController = UIAlertController(title: "Sign In", message: "Please sign in again to \(message)", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Sign In", style: .default, handler: { (_) in
            self.turnOnActivityIndicator()
            GIDSignIn.sharedInstance()?.signIn()
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeUsername(completion: @escaping (_ success: Bool, _ needsReauth: Bool) -> Void) {
        var usernameTextField: UITextField!
        let alertController = UIAlertController(title: "Change Username", message: "Enter your new username", preferredStyle: .alert)
        
        alertController.addTextField { (textfield) in
            textfield.placeholder = "Enter new username..."
            usernameTextField = textfield
        }
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        alertController.addAction(UIAlertAction(title: "Change", style: .default, handler: { (_) in
            guard let username = usernameTextField.text, !username.isEmpty else {
                self.presentMissingInfoAlert()
                completion(false, false)
                return
            }
            
            self.turnOnActivityIndicator()
            
            let changeRequest = self.user.createProfileChangeRequest()
            changeRequest.displayName = username
            changeRequest.commitChanges(completion: { (error) in
                if let error = error {
                    print("Error changing display name for FIRUser : \(error) : \(error.localizedDescription)")
                    completion(false, false)
                    self.turnOffActivityIndicator()
                    return
                }
                DBFUserController.shared.updateLoggedInUser(withUsername: username, completion: { (success) in
                    if success {
                        completion(true, false)
                    } else {
                        completion(false, false)
                    }
                    self.turnOffActivityIndicator()
                })
            })
        }))
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    func deleteAccount(completion: @escaping (_ success: Bool, _ needsReauth: Bool) -> Void) {
        let alertController = UIAlertController(title: "Are you sure you want to delete your account?", message: "You can not recover any data!", preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        alertController.addAction((UIAlertAction(title: "Delete", style: .destructive, handler: { (_) in
            self.turnOnActivityIndicator()
            self.user.delete { (error) in
                if let error = error {
                    guard let errorCode = AuthErrorCode(rawValue: error._code) else {
                        print("An error occured when deleting FIRUser : \(error) : \(error.localizedDescription)")
                        self.turnOffActivityIndicator()
                        completion(false, false)
                        return
                    }
                    if errorCode == AuthErrorCode(rawValue: 17014) {
                        self.turnOffActivityIndicator()
                        completion(false, true)
                        return
                    }
                }
                
                DBFUserController.shared.delete(dbfUser: self.dbfUser, completion: { (success) in
                    if success {
                        completion(true, false)
                    }
                })
            }
        })))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func changeUsersEmailAddress(to email: String, completion: @escaping (_ success: Bool, _ needsReauth: Bool) -> Void) {
        user.updateEmail(to: email) { (error) in
            if let error = error {
                let alertController = AlertManager.displayAlertMessage(userMessage: error.localizedDescription)
                self.present(alertController, animated: true, completion: nil)
                completion(false, true)
                return
            }
            
            completion(true, false)
        }
    }
    
    func popToSplashScreen() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "SplashScreen", bundle: nil)
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = storyboard.instantiateInitialViewController()
        }
    }
    
    func setUpViews() {
        usernameLabel.text = dbfUser.username
        emailLabel.text = user.email
        if provider == "google.com" {
            changeEmailButton.isHidden = true
        }
    }
    
    
    func turnOnActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = false
            self.changeUsernameButton.isEnabled = false
            self.changeEmailButton.isEnabled = false
            self.resetPasswordButton.isEnabled = false
            self.signOutButton.isEnabled = false
            self.deleteAccountButton.isEnabled = false
        }
    }
    
    func turnOffActivityIndicator() {
        DispatchQueue.main.async {
            self.activityIndicator.isHidden = true
            self.changeUsernameButton.isEnabled = true
            self.resetPasswordButton.isEnabled = true
            self.changeEmailButton.isEnabled = true
            self.signOutButton.isEnabled = true
            self.deleteAccountButton.isEnabled = true
        }
    }
    
    func presentMissingInfoAlert() {
        let missingDataAlertController = UIAlertController(title: "Missing data", message: "All fields need to be filled out to proceed", preferredStyle: .alert)
        missingDataAlertController.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
        
        DispatchQueue.main.async {
            self.present(missingDataAlertController, animated: true)
        }
    }
}

// MARK: - GIDSignInDelegate Methods
extension SettingsViewController: GIDSignInDelegate {
    
    func sign(_ signIn: GIDSignIn!, didSignInFor user: GIDGoogleUser!, withError error: Error!) {
        if let error = error {
            print("Error signing into firebase from google: \(error) : \(error.localizedDescription)")
            self.turnOffActivityIndicator()
            return
        }
        
        guard let authentication = user.authentication else { return }
        
        credential = GoogleAuthProvider.credential(withIDToken: authentication.idToken, accessToken: authentication.accessToken)
        reauthenticateGoogleUser { (success) in
            if success {
                self.turnOffActivityIndicator()
                let alertController = AlertManager.displayAlertMessage(userMessage: "Re-sign in successful")
                self.present(alertController, animated: true, completion: nil)
            } else {
                self.turnOffActivityIndicator()
                let alertController = AlertManager.displayAlertMessage(userMessage: "Something unexpected happened")
                self.present(alertController, animated: true, completion: nil)
            }
        }
    }
}

// MARK: - GIDSignInUIDelegate Methods
extension SettingsViewController: GIDSignInUIDelegate {
    
    
}

