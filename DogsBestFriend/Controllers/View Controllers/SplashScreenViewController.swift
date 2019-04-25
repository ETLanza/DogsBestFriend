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
        DBFUserController.shared.fetchUser { (success) in
            if success {
                self.presentOnboarding()
            } else {
                self.presentAuthView()
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
    
    
    func authUI(_ authUI: FUIAuth, didSignInWith authDataResult: AuthDataResult?, error: Error?) {
        
        if let error = error {
            print("Error with firebase Sign In: \(error) : \(error.localizedDescription)")
            return
        }
        
        if let authDataResult = authDataResult {
            DBFUserController.shared.checkIfDBFUserExistFor(user: authDataResult.user) { (dbfUser) in
                if let dbfUser = dbfUser {
                    DogController.shared.fetchDogsFor(dbfUser: dbfUser, completion: { (success) in
                        if success {
                            ParkController.shared.fetchFavoriteParksFor(dbfUser: dbfUser, completion: { (success) in
                                if success {
                                    WalkController.shared.fetchWalksFor(dbfUser: dbfUser, completion: { (success) in
                                        if success {
                                            self.presentOnboarding()
                                        }
                                    })
                                }
                            })
                        }
                    })
                } else {
                    DBFUserController.shared.createNewUserFrom(firebase: authDataResult.user) { (success) in
                        if success {
                            self.presentOnboarding()
                        }
                    }
                }
            }
        }
    }
    
    func presentAuthView() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = UIStoryboard(name: "SignUp", bundle: nil).instantiateInitialViewController()
        }
    }
    
    func presentOnboarding() {
        DispatchQueue.main.async {
            let appDelegate = UIApplication.shared.delegate as! AppDelegate
            appDelegate.window?.rootViewController = OnboardViewController()
        }
    }
}
