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
    var uuid: String
    
    init(latitude: Double, longitude: Double, timestamp: Date, uuid: String = UUID().uuidString) {
        self.latitude = latitude
        self.longitude = longitude
        self.timestamp = timestamp
        self.uuid = uuid
    }
    
    static func == (lhs: Location, rhs: Location) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension Location {
    convenience init?(dictionary: [String: Any]) {
        guard let latitude = dictionary[Keys.Location.latitude] as? Double,
            let longitude = dictionary[Keys.Location.longitude] as? Double,
            let timestampAsDouble = dictionary[Keys.Location.timestamp] as? TimeInterval,
            let uuid = dictionary[Keys.Location.uuid] as? String
            else { return nil }
        
        let timestamp = Date(timeIntervalSince1970: timestampAsDouble)
        
        self.init(latitude: latitude, longitude: longitude, timestamp: timestamp, uuid: uuid)
    }
    
    var asDictionary: [String: Any] {
        return [Keys.Location.latitude: self.latitude,
                Keys.Location.longitude: self.longitude,
                Keys.Location.timestamp: self.timestamp.timeIntervalSince1970,
                Keys.Location.uuid: self.uuid]
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
