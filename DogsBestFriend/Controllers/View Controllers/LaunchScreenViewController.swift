//
//  LaunchScreenViewController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/17/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import CoreLocation
import UIKit

class LaunchScreenViewController: UIViewController {
    
    var presentTriggered: Bool = false
    
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

    func presentMainView() {
        if presentTriggered == false {
            presentTriggered = true
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let newViewController = storyboard.instantiateInitialViewController()
            newViewController?.modalPresentationStyle = .fullScreen
            newViewController?.modalTransitionStyle = .crossDissolve
            present(newViewController!, animated: true, completion: nil)
        }
    }
}

extension LaunchScreenViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        switch status {
        case .restricted, .notDetermined:
            break
        default:
            presentMainView()
        }
    }
}
