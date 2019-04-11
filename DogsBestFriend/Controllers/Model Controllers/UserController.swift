//
//  UserController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth

class UserController {
    // MARK: - Shared Instance
    
    static let shared = UserController()
    
    private init() {        
        db = Firestore.firestore()
    }
    
    // MARK: - Properties
    
    var loggedInUser: DBFUser?
    var db: Firestore!
    
    // MARK: - CRUD Functions
    
    func createNewUserFrom(firebase user: User, completion: @escaping (Bool) -> Void) {
        let documentRef = db.collection("users").document(user.uid)
        let newUser = DBFUser(username: user.displayName ?? "New User", uuid: user.uid, documentRef: documentRef)
        
        documentRef.setData(newUser.asDictionary) { (error) in
            if let error = error {
                NSLog("Error saving User: %@ : %@ : %@", [newUser, error, error.localizedDescription])
                completion(false)
                return
            }
            
            self.loggedInUser = newUser
            completion(true)
        }
    }
    
    func fetchUser(completion: @escaping (Bool) -> Void) {
        if let authedUser = Auth.auth().currentUser  {
            self.checkIfDBFUserExistFor(user: authedUser) { (dbfUser) in
                if let dbfUser = dbfUser {
                    self.loggedInUser = dbfUser
                    completion(true)
                }
            }
        } else {
            completion(false)
        }
    }
    
    func checkIfDBFUserExistFor(user: User, completion: @escaping (DBFUser?) -> Void) {
        db.collection("users").document(user.uid).getDocument { (snapshot, error) in
            if let error = error {
                NSLog("No DBFUser found for UUID: %@ : %@ : %@", [user.uid, error, error.localizedDescription])
                completion(nil)
                return
            }
            
            guard let userDictionary = snapshot?.data() else {
                NSLog("Unable to get user data for UUID: %@", [user.uid])
                completion(nil)
                return
            }
            
            let dbfUser = DBFUser(jsonDictionary: userDictionary)
            completion(dbfUser)
        }
    }
    
    func saveLoggedInUser(completion: @escaping (Bool) -> Void) {
        guard let user = loggedInUser else {
            NSLog("No loggedInUser found to save")
            completion(false); return }
        user.documentRef.setData(user.asDictionary){ (error) in
            if let error = error {
                NSLog("Error saving logged in user with UUID: %@ : %@ : %@", [user.uuid, error, error.localizedDescription])
                completion(false)
                return
            }
            completion(true)
        }
    }
}
