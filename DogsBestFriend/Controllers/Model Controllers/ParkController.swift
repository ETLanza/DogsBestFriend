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

    var parks: [Park] = []
    var favoriteParks: [Park] = []

    // MARK: - CRUD Functions

    func addParkwith(placemark: MKPlacemark) {
        let newPark = Park(placemark: placemark)
        parks.append(newPark)
    }

    func addFavorite(park: Park, completion: @escaping (Bool) -> Void) {
        
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = park.asData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error adding favorite park to database: %@", error.localizedDescription)
                completion(false)
                return
            }
            
            if data != nil {
                self.favoriteParks.append(park)
                completion(true)
                return
            }
            
            NSLog("Error adding favorite park to local controller")
            completion(false)
        }
    }

    func deleteFavorite(park: Park, completion: @escaping (Bool) -> Void) {
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DEL"
        request.httpBody = park.asData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting favorite park from database: %@", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let index = self.favoriteParks.index(of: park) else { completion(false); return }
            self.favoriteParks.remove(at: index)
            completion(true)
        }
    }

    func removeAllNonFavoriteParks() {
        parks = []
    }
}
