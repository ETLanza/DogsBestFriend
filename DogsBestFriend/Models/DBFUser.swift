//
//  User.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class DBFUser {
    let username: String
    let uuid: String
    var dogs: [Dog]
    var walks: [Walk]
    var favoriteParks: [Park]
    
    init(username: String, uuid: String, dogs: [Dog] = [], walks: [Walk] = [], favoriteParks: [Park] = []) {
        self.username = username
        self.uuid = uuid
        self.dogs = dogs
        self.walks = walks
        self.favoriteParks = favoriteParks
    }
}

extension DBFUser {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let username = jsonDictionary[Keys.User.username] as? String,
            let dogs = jsonDictionary[Keys.User.dogs] as? [Dog],
            let uuid = jsonDictionary[Keys.User.uuid] as? String,
            let walks = jsonDictionary[Keys.User.walks] as? [Walk],
            let favoriteParks = jsonDictionary[Keys.User.favoriteParks] as? [Park]
            else { return nil }
        
        self.init(username: username, uuid: uuid, dogs: dogs, walks: walks, favoriteParks: favoriteParks)
    }
    
    var asJSONDictionary: [String: Any] {
        let dogsAsDictionaries = self.dogs.map { $0.asDictionary }
        let walksAsDictionaries = self.walks.map { $0.asDictionary }
        let favoriteParksAsDictionaries = self.favoriteParks.map { $0.asDictionary }
        return [Keys.User.username: self.username,
                Keys.User.uuid: self.uuid,
                Keys.User.dogs: dogsAsDictionaries,
                Keys.User.walks: walksAsDictionaries,
                Keys.User.favoriteParks: favoriteParksAsDictionaries]
    }
    
    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asJSONDictionary, options: .prettyPrinted)
    }
}
