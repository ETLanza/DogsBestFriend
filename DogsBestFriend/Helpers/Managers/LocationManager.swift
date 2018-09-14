//
//  LocationManager.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/13/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager {
    
    // MARK: - Singleton
    static let shared = CLLocationManager() ; private init() { }
    
}
