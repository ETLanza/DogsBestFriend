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
        switch CLLocationManager.authorizationStatus() {
        case .notDetermined:
            LocationManager.shared.requestWhenInUseAuthorization()
        default:
            presentMainView()
        }
    }

    // MARK: - Helper Method
    
    func presentMainView() {
        if presentTriggered == false {
            LocationManager.shared.requestLocation()
            presentTriggered = true
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
        switch status {
        case .restricted, .notDetermined:
            break
        default:
            presentMainView()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        NSLog("Error with location manager: %@", error.localizedDescription)
    }
}
