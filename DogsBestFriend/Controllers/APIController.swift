//
//  APIController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class APIController {
    // MARK: - Shared Instance
    
    static let shared = APIController()
    
    let baseURL = URL(string: "https://nathanlanza.com/dog")
    
    func getAllDataOf(type: String, completion: @escaping (Bool) -> Void) {
        let url = baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error retreiving data from API: %@", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = data else { completion(false); return }
            
            let jsonDecoder = JSONDecoder()
            
            do {
                let _ = try jsonDecoder.decode(Dog.self, from: data)
            } catch let error {
                NSLog("Error decoing from JSON: &%", error.localizedDescription)
                completion(false)
                return
            }
        }.resume()
    }
    
    func delete(record: [String: Any], completion: @escaping (Bool) -> Void) {
        
    }
}
