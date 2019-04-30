//
//  OnboardViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/17/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import CoreLocation
import UIKit

class OnboardViewController: UIViewController {
    
    // MARK: - Properties
    
    var presentTriggered: Bool = false
    
    // MARK: - Life Cycle Method
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        LocationManager.shared.delegate = self
        if CLLocationManager.authorizationStatus() != .notDetermined {
            presentMainView()
        } else {
            LocationManager.shared.requestWhenInUseAuthorization()
        }
    }
    
    // MARK: - Helper Method
    
    func presentMainView() {
        if presentTriggered == false {
            presentTriggered = true
            LocationManager.shared.requestLocation()
            let storyboard = UIStoryboard(name: "TabBar", bundle: nil)
            let newViewController = storyboard.instantiateInitialViewController()
            newViewController?.modalPresentationStyle = .fullScreen
            newViewController?.modalTransitionStyle = .crossDissolve
            present(newViewController!, animated: true, completion: nil)
        }
    }
}

// MARK: - Location Manager Delegate

extension OnboardViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            presentMainView()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error with location manager: %@", error.localizedDescription)
    }
}
