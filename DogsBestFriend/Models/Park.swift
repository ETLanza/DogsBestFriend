//
//  Park.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import MapKit

class Park: Equatable {

    var isFavorite: Bool
    var name: String
    var latitude: Double
    var longitude: Double
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }

    init(name: String, latitude: Double, longitude: Double, isFavorite: Bool = false) {
        self.name = name
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
    
    // MARK: Equatable

    static func == (lhs: Park, rhs: Park) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Park {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let name = jsonDictionary[Keys.Park.name] as? String,
            let latitude = jsonDictionary[Keys.Park.latitude] as? Double,
            let longitude = jsonDictionary[Keys.Park.longitude] as? Double,
        let isFavorite = jsonDictionary[Keys.Park.isFavorite] as? Bool
            else { return nil }
        self.init(name: name, latitude: latitude, longitude: longitude, isFavorite: isFavorite)
    }

    var asDictionary: [String: Any] {
        return [Keys.Park.name: self.name,
                Keys.Park.latitude: self.latitude,
                Keys.Park.longitude: self.longitude,
                Keys.Park.isFavorite: self.isFavorite]
    }

    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asDictionary, options: .prettyPrinted)
    }
}


