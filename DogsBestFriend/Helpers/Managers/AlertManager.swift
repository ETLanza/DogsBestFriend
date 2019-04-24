//
//  AlertManager.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/26/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import CoreLocation

class AlertManager {
    
    static func displayAlertMessage(userMessage: String) -> UIAlertController {
        let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        return alertController
    }
    
    static func presentLocationAlert() -> UIAlertController {
        let alertController = UIAlertController(title: "Your location services are disabled for this application.", message: "Please go to settings and enable location services to track your activities.", preferredStyle: .alert)
        let enableAction = UIAlertAction(title: "Go to Settings", style: .default) { (_) in
            if !CLLocationManager.locationServicesEnabled() {
                if let appSettings = URL(string: UIApplication.openSettingsURLString) {
                    UIApplication.shared.open(appSettings, options: [:], completionHandler: nil)
                }
            }
        }
        
        let dismissAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        alertController.addAction(enableAction)
        alertController.addAction(dismissAction)
        return alertController
    }
}
