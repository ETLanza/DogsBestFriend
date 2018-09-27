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
        
        completion(newWalk) //TODO: REMOVE AFTER DATABASE IS FINALIZED
        
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = newWalk.asData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error saving walk to database: %@", error.localizedDescription)
                completion(nil)
                return
            }
            completion(newWalk)
        }
    }

    func delete(walk: Walk, completion: @escaping (Bool) -> Void) {
        if let index = walks.index(of: walk) {
            walks.remove(at: index)
        }
        
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DEL"
        request.httpBody = walk.asData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting walk from database: %@", error.localizedDescription)
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    // MARK: - Helper Methods
    
    func add(location: Location, toWalk walk: Walk) {
        walk.locations.append(location)
    }
}
