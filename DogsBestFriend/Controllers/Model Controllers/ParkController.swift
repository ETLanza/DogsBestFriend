//
//  ParkController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import MapKit

class ParkController {
    // MARK: - Shared Instance
    
    static let shared = ParkController()
    
    // MARK: - Properties
    
    var favoriteParks: [Park] = []
    
    // MARK: - CRUD Functions
    
    func addParkwith(placemark: MKPlacemark) {
        let newPark = Park(placemark: placemark)
        favoriteParks.append(newPark)
    }
    
    func delete(park: Park) {
        let index = favoriteParks.index(of: park)
        favoriteParks.remove(at: index!)
    }
    
}
