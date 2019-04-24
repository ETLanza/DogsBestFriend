//
//  Location.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class Location: Equatable, Codable {
    
    var latitude: Double
    var longitude: Double
    var timestamp: Date
    
    init(latitude: Double, longitude: Double, timestamp: Date) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude && lhs.timestamp == rhs.timestamp
    }
}

extension Location {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let latitude = jsonDictionary[Keys.Location.latitude] as? Double,
            let longitude = jsonDictionary[Keys.Location.longitude] as? Double,
            let timestamp = jsonDictionary[Keys.Location.timestamp] as? Date
            else { return nil }
        
        self.init(latitude: latitude, longitude: longitude, timestamp: timestamp)
    }
    
    var asDictionary: [String: Any] {
        return [Keys.Location.latitude: self.latitude,
                Keys.Location.longitude: self.longitude,
                Keys.Location.timestamp: self.timestamp]
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
