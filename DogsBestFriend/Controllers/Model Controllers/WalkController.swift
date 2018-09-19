//
//  WalkController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class WalkController {

    // MARK: - Shared Instance
    static let shared = WalkController()

    var walks: [Walk] = []

    // MARK: - CRUD Functions
    func createNewWalk(distance: Double, timestamp: Date, duration: Int, locations: [Location], completion: @escaping (Walk?) -> Void) {
        let newWalk = Walk(distance: distance, timestamp: timestamp, duration: duration)
        completion(newWalk)
    }

    func add(location: Location, toWalk walk: Walk) {
        walk.locations.append(location)
    }

    func delete(walk: Walk) {
        if let index = walks.index(of: walk) {
            walks.remove(at: index)
        }
    }
}
