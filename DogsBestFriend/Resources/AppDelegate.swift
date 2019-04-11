//
//  AppDelegate.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 7/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import Firebase
import FirebaseUI


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, FUIAuthDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        FirebaseApp.configure()
        FUIAuth.defaultAuthUI()?.shouldHideCancelButton = true
        let authUI = FUIAuth.defaultAuthUI()!
        
        authUI.delegate = self
        
        let providers: [FUIAuthProvider] = [
            FUIGoogleAuth()
        ]
        authUI.providers = providers
        
        presentAuthView(authUI)
        
        return true
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
    
    func presentAuthView(_ authUI: FUIAuth) {
        let fuiAuthPickerViewController = authUI.delegate?.authPickerViewController!(forAuthUI: authUI)
        
        let rootNavigationController = authUI.authViewController()
        rootNavigationController.setViewControllers([fuiAuthPickerViewController!], animated: true)
        rootNavigationController.modalTransitionStyle = .coverVertical
        
        rootNavigationController.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        rootNavigationController.navigationBar.shadowImage = UIImage()
        rootNavigationController.navigationBar.prefersLargeTitles = true
        rootNavigationController.navigationBar.tintColor = .black
        
        
        window?.rootViewController = rootNavigationController
    }
}
