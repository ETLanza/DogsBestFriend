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
    var locations: [Location] = []

    init(distance: Double, timestamp: Date, duration: Int) {
        self.distance = distance
        self.timestamp = timestamp
        self.duration = duration
    }

    static func == (lhs: Walk, rhs: Walk) -> Bool {
        return lhs.distance == rhs.distance && lhs.timestamp == rhs.timestamp && lhs.duration == rhs.duration
    }
}
