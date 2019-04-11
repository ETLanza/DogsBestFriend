//
//  APIManager.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/26/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class APIManager {
    // MARK: - Shared Instance
    
    static let shared = APIManager()
    
    func getAllDataFor(user: DBFUser, completion: @escaping (Bool) -> Void) {
        let url = Private.baseURL!.appendingPathComponent("User")
        let searchUsername = UserController.shared.loggedInUser?.username
        
        var components = URLComponents(url: url, resolvingAgainstBaseURL: true)
        components?.queryItems = [URLQueryItem.init(name: "username", value: searchUsername)]
        
        var request = URLRequest(url: components!.url!)
        request.httpMethod = "GET"
        request.httpBody = nil
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error fetching User's data from database: %@", error.localizedDescription)
                completion(false)
                return
            }
            
            guard let data = data else {
                NSLog("No User Data found from database")
                completion(false)
                return
            }
            
            do {
                let userData = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String: Any]
                
                let dogsJSON = userData?[Keys.User.dogs] as? [[String: Any]]
                dogsJSON?.forEach({ (dog) in
                    let newDog = Dog(jsonDictionary: dog)
                    UserController.shared.loggedInUser?.dogs.append(newDog!)
                })
                
                let parksJSON = userData?[Keys.User.favoriteParks] as? [[String: Any]]
                parksJSON?.forEach({ (park) in
                    let newPark = Park(jsonDictionary: park)
                    UserController.shared.loggedInUser?.favoriteParks.append(newPark!)
                })
                
                let walksJSON = userData?[Keys.User.walks] as? [[String: Any]]
                walksJSON?.forEach({ (walk) in
//                    let newWalk = Walk(jsonDictionary: walk)
//                    UserController.shared.loggedInUser?.walks.append(newWalk)
                })
                completion(true)
            } catch {
                NSLog("Error Serrializing User Data from Database")
                completion(false)
            }
        }.resume()
    }
}
