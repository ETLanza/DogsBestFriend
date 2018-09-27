//
//  User.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class User {
    let username: String
    var dogs: [Dog]
    var walks: [Walk]
    var favoriteParks: [Park]

    init(username: String, dogs: [Dog] = [], walks: [Walk] = [], favoriteParks: [Park] = []) {
        self.username = username
        self.dogs = dogs
        self.walks = walks
        self.favoriteParks = favoriteParks
    }
}

extension User {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let dogs = jsonDictionary[Keys.User.dogs] as? [Dog],
        let walks = jsonDictionary[Keys.User.walks] as? [Walk],
        let favoriteParks = jsonDictionary[Keys.User.favoriteParks] as? [Park]
            else { return nil }
        
        self.init(username: UserController.shared.loggedInUser!.username, dogs: dogs, walks: walks, favoriteParks: favoriteParks)
    }
    
    var asJSONDictionary: [String: Any] {
        return [Keys.User.username: self.username,
                Keys.User.dogs: self.dogs,
                Keys.User.walks: self.walks,
                Keys.User.favoriteParks: self.favoriteParks]
    }
    
    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asJSONDictionary, options: .prettyPrinted)
    }
}
