//
//  LocationManager.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import CoreLocation
import Foundation

class LocationManager {
    // MARK: - Shared Instance

    static let shared = CLLocationManager()
    private init() {
        LocationManager.shared.desiredAccuracy = kCLLocationAccuracyBest
    }
}
