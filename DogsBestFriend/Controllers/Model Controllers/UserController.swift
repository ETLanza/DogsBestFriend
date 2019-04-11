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
    var fbDocRef: DocumentReference?
    var db: Firestore!
    
    // MARK: - CRUD Functions
    
    func createNewUserFrom(firebase user: User, completion: @escaping (Bool) -> Void) {
        let newUser = DBFUser(username: user.displayName ?? "New User", uuid: user.uid)
        db.collection("users").document(newUser.uuid).setData(newUser.asJSONDictionary) { (error) in
            if let error = error {
                NSLog("Error saving User: %@ : %@ : %@", [newUser, error, error.localizedDescription])
                completion(false)
                return
            }
            
            self.loggedInUser = newUser
            self.fbDocRef = self.db.collection("users").document(newUser.uuid)
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
}
