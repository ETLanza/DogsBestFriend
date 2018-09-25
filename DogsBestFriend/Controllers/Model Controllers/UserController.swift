//
//  UserController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class UserController {
    // MARK: - Shared Instance
    
    static let shared = UserController()
    
    // MARK: - Properties
    
    var loggedInUser: User?
    
    // MARK: - CRUD Functions
    
    func signUpUser() {
        
    }
    
    func loginUser(completion: @escaping (Bool) -> Void) {
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error loging in user: %@", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = data else { completion(false); return }
            
        }
    }
    
    func encryptPassword() {
        
    }
}
