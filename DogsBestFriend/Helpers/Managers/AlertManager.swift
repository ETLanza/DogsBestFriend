//
//  AlertManager.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/26/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

class AlertManager {
    
    static func displayAlertMessage(userMessage: String) -> UIAlertController{
        let alertController = UIAlertController(title: nil, message: userMessage, preferredStyle: .alert)
        
        let okayAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okayAction)
        return alertController
    }
}