//
//  WalkController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase

class WalkController {
    
    // MARK: - Shared Instance
    static let shared = WalkController()
    
    let dbRef = Firestore.firestore().collection("walks")

    // MARK: - CRUD Functions
    
    //TODO: CONVERT TO FIREBASE

    func createNewWalk(distance: Double, timestamp: Date, duration: Int, locations: [Location], completion: @escaping (Walk?) -> Void) {
        
        let documentRef = dbRef.document()
        let newWalk = Walk(distance: distance, timestamp: timestamp, duration: duration, documentRef: documentRef, ownerDocumentRef: DBFUserController.shared.loggedInUser.documentRef)
        
        completion(newWalk)
    }

    func delete(walk: Walk, completion: @escaping (Bool) -> Void) {

    }
    
    // MARK: - Helper Methods
    
    func add(locations: [Location], toWalk walk: Walk, completion: @escaping (Bool) -> Void) {
        walk.locations = locations
        completion(true)
    }
    
    func saveWalkToFirebase(walk: Walk, completion: @escaping (Bool) -> Void) {
        walk.documentRef.setData(walk.asDictionary) { (error) in
            if let error = error {
                print("Error saving \(walk.uuid) to firebase : \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }
    
    func fetchWalksFor(dbfUser: DBFUser, completion: @escaping (Bool) -> Void) {
        let dg = DispatchGroup()
        dbfUser.walkReferences.forEach { (documentRef) in
            dg.enter()
            documentRef.getDocument(completion: { (snapshot, error) in
                if let error = error {
                    print("Error fetching walk for \(dbfUser.username) : \(error) : \(error.localizedDescription)")
                    dg.leave()
                    return
                }
                
                guard let walkDict = snapshot?.data() else {
                    print("Error turning \(snapshot!.documentID) snapshot into walk dictionary")
                    dg.leave()
                    return
                }
                
                guard let newWalk = Walk(dictionary: walkDict) else {
                    print("Error with walk dictionary init")
                    dg.leave()
                    return
                }
                dbfUser.walks.append(newWalk)
                dg.leave()
            })
        }
        dg.notify(queue: .main) {
            completion(true)
        }
    }
}
