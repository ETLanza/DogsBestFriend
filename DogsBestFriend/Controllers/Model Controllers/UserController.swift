//
//  UserController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import CommonCrypto

class UserController {
    // MARK: - Shared Instance
    
    static let shared = UserController()
    
    // MARK: - Properties
    
    var loggedInUser: User?
    
    // MARK: - CRUD Functions
    
    func signUp(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let encryptedPassword = Private.encrypt(password: password)
        
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["username": username, "password": encryptedPassword], options: .prettyPrinted)
        } catch let error {
            NSLog("Error encoding HTTPBody: %@", error.localizedDescription)
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error performing signUp data task: %@", error.localizedDescription)
                completion(false)
                return
            }
            do {
                let jsonFromData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: String]
                
                if let jsonDict = jsonFromData {
                    let username = jsonDict[Keys.User.username]
                    
                    if (username?.isEmpty)! {
                        NSLog("Could not get Username from JSON Data")
                        completion(false)
                        return
                    } else {
                        completion(true)
                        return
                    }
                }
            } catch {
                NSLog("Could not serialize user data from database")
                completion(false)
            }
        }.resume()
    }
    
    func login(username: String, password: String, completion: @escaping (Bool) -> Void) {
        let encryptedPassword = Private.encrypt(password: password)

        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: ["username": username, "password": encryptedPassword], options: .prettyPrinted)
        } catch let error {
            NSLog("Error encoding HTTPBody: %@", error.localizedDescription)
            completion(false)
            return
        }
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error performing login data task: %@", error.localizedDescription)
                completion(false)
                return
            }
            do {
                let jsonFromData = try JSONSerialization.jsonObject(with: data!, options: .mutableContainers) as? [String: String]
                
                if let jsonDict = jsonFromData {
                    let username = jsonDict[Keys.User.username]
                    
                    if (username?.isEmpty)! {
                        NSLog("Could not get Username from JSON Data")
                        completion(false)
                        return
                    } else {
                        completion(true)
                        return
                    }
                }
            } catch {
                NSLog("Could not serialize user data from database")
                completion(false)
            }
            }.resume()
    }
}
