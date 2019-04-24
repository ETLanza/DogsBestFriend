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
    
    //TODO CONVERT TO FIREBASE

    func addParkwith(placemark: MKPlacemark) {
        let newPark = Park(name: placemark.name ?? "Unknown Park", latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        parks.append(newPark)
    }

    func addFavorite(park: Park, completion: @escaping (Bool) -> Void) {
        
        // MARK: - DELETE THIS AFTER API FINISHED
        self.favoriteParks.append(park)
        completion(true)
    }

    func deleteFavorite(park: Park, completion: @escaping (Bool) -> Void) {
        
        // MARK: - DELETE THIS AFTER API FINISHED
        guard let index = self.favoriteParks.firstIndex(of: park) else { completion(false); return }
        self.favoriteParks.remove(at: index)
        completion(true)
    }

    func removeAllNonFavoriteParks() {
        parks = []
    }
    
    func getPlacemarkFor(park: Park, completion: @escaping (MKPlacemark?)-> Void){
        let geocoder = CLGeocoder()
        var placemark = MKPlacemark()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: park.latitude, longitude: park.longitude)) { (placemarks, error) in
            if let error = error {
                print("Error getting placemark for park: \(park.name) : \(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }
            
            guard let newPlacemark = placemarks?.first else { completion(nil); return }
            
            placemark = MKPlacemark(placemark: newPlacemark)
            completion(placemark)
        }
    }
}
