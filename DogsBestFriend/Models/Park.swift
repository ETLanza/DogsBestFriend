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
    var address: String
    var latitude: Double
    var longitude: Double
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }

    init(name: String, address: String, latitude: Double, longitude: Double, isFavorite: Bool = false) {
        self.name = name
        self.address = address
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
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[Keys.Park.name] as? String,
            let address = dictionary[Keys.Park.address] as? String,
            let latitude = dictionary[Keys.Park.latitude] as? Double,
            let longitude = dictionary[Keys.Park.longitude] as? Double,
        let isFavorite = dictionary[Keys.Park.isFavorite] as? Bool
            else { return nil }
        self.init(name: name, address: address, latitude: latitude, longitude: longitude, isFavorite: isFavorite)
    }

    var asDictionary: [String: Any] {
        return [Keys.Park.name: self.name,
                Keys.Park.address: self.address,
                Keys.Park.latitude: self.latitude,
                Keys.Park.longitude: self.longitude,
                Keys.Park.isFavorite: self.isFavorite]
    }

    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asDictionary, options: .prettyPrinted)
    }
}


