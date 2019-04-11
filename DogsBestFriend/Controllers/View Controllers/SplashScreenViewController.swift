//
//  SplashScreenViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 4/10/19.
//  Copyright © 2019 ETLanza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI

class SplashScreenViewController: UIViewController, FUIAuthDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UserController.shared.fetchUser { (success) in
            if success {
                self.presentOnboarding()
            } else {
                FUIAuth.defaultAuthUI()?.shouldHideCancelButton = true
                let authUI = FUIAuth.defaultAuthUI()!
                
                authUI.delegate = self
                
                let providers: [FUIAuthProvider] = [
                    FUIGoogleAuth()
                ]
                authUI.providers = providers
                
                self.presentAuthView(authUI)
            }
        }
    }
    
    func application(_ app: UIApplication, open url: URL,
                     options: [UIApplication.OpenURLOptionsKey : Any]) -> Bool {
        let sourceApplication = options[UIApplication.OpenURLOptionsKey.sourceApplication] as! String?
        if FUIAuth.defaultAuthUI()?.handleOpen(url, sourceApplication: sourceApplication) ?? false {
            return true
        }
        // other URL handling goes here.
        return false
    }
    
    func authPickerViewController(forAuthUI authUI: FUIAuth) -> FUIAuthPickerViewController {
        return SignInViewController(nibName: "SignInViewController", bundle: Bundle.main, authUI: authUI)
    }
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if let error = error {
            NSLog("Error with firebase Sign In: %@ : %@", [error, error.localizedDescription])
            return
        }
        
        if let authDataResult = authDataResult {
            UserController.shared.checkIfDBFUserExistFor(user: authDataResult.user) { (dbfUser) in
                if dbfUser != nil {
                    self.presentOnboarding()
                } else {
                    UserController.shared.createNewUserFrom(firebase: authDataResult.user) { (success) in
                        if success {
                            self.presentOnboarding()
                        }
                    }
                }
            }
        }
    }
    
    func presentAuthView(_ authUI: FUIAuth) {
        let fuiAuthPickerViewController = authUI.delegate?.authPickerViewController!(forAuthUI: authUI)
        
        let rootNavigationController = authUI.authViewController()
        rootNavigationController.setViewControllers([fuiAuthPickerViewController!], animated: true)
        rootNavigationController.modalTransitionStyle = .coverVertical
        
        rootNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        rootNavigationController.navigationBar.shadowImage = UIImage()
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.tintColor = .black
        
        DispatchQueue.main.async {
            self.present(rootNavigationController, animated: true, completion: nil)
        }
    }
    
    func presentOnboarding() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        DispatchQueue.main.async {
            appDelegate.window?.rootViewController = OnboardViewController()
        }
    }
}
