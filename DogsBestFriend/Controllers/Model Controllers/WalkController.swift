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
    
    //TODO: CONVERT TO FIREBASE

    func createNewWalk(distance: Double, timestamp: Date, duration: Int, locations: [Location], completion: @escaping (Walk?) -> Void) {

    }

    func delete(walk: Walk, completion: @escaping (Bool) -> Void) {

    }
    
    // MARK: - Helper Methods
    
    func add(location: Location, toWalk walk: Walk) {
        walk.locations.append(location)
    }
}
