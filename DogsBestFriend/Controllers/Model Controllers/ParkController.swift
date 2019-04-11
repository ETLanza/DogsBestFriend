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
        let newPark = Park(name: placemark.name ?? "Unknown Park", latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        newPark.placemark = placemark
        parks.append(newPark)
    }

    func addFavorite(park: Park, completion: @escaping (Bool) -> Void) {
        
        // MARK: - DELETE THIS AFTER API FINISHED
        self.favoriteParks.append(park)
        completion(true)
        return
        // END DELETE
        
        
        let url = Private.baseURL!.appendingPathComponent("parks")
        
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
        
        // MARK: - DELETE THIS AFTER API FINISHED
        guard let index = self.favoriteParks.firstIndex(of: park) else { completion(false); return }
        self.favoriteParks.remove(at: index)
        completion(true)
        return
        // END DELETE
        
        
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
            
            guard let index = self.favoriteParks.firstIndex(of: park) else { completion(false); return }
            self.favoriteParks.remove(at: index)
            completion(true)
        }
    }

    func removeAllNonFavoriteParks() {
        parks = []
    }
    
    func getPlacemarkFor(park: Park, completion: @escaping (MKPlacemark?)-> Void){
        let geocoder = CLGeocoder()
        var placemark = MKPlacemark()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: park.latitude, longitude: park.longitude)) { (placemarks, error) in
            if let error = error {
                NSLog("Error getting placemark for park: %@", [park.name, error.localizedDescription])
                completion(nil)
                return
            }
            
            guard let newPlacemark = placemarks?.first else { completion(nil); return }
            
            placemark = MKPlacemark(placemark: newPlacemark)
            completion(placemark)
        }
    }
}
