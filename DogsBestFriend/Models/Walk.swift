//
//  Walk.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class Walk: Equatable, Codable {
    
    var distance: Double
    var timestamp: Date
    var duration: Int
    var locations: [Location]
    
    init(distance: Double, timestamp: Date, duration: Int, locations: [Location] = []) {
        self.distance = distance
        self.timestamp = timestamp
        self.duration = duration
        self.locations = locations
    }
    
    static func == (lhs: Walk, rhs: Walk) -> Bool {
        return lhs.distance == rhs.distance && lhs.timestamp == rhs.timestamp && lhs.duration == rhs.duration
    }
}

extension Walk {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let distance = jsonDictionary[Keys.Walk.distance] as? Double,
            let timestamp = jsonDictionary[Keys.Walk.distance] as? Date,
            let duration = jsonDictionary[Keys.Walk.duration] as? Int,
            let locations = jsonDictionary[Keys.Walk.locations] as? [Location]
            else { return nil }
        
        self.init(distance: distance, timestamp: timestamp, duration: duration, locations: locations)
    }
    
    var asDictionary: [String: Any] {
        return [Keys.Walk.distance: self.distance,
                Keys.Walk.timestamp: self.timestamp,
                Keys.Walk.duration: self.duration,
                Keys.Walk.locations: self.locations]
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
