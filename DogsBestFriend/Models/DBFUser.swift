//
//  User.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/24/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase

class DBFUser {
    let username: String
    let uuid: String
    var dogs: [Dog]
    var walks: [Walk]
    var favoriteParks: [Park]
    var documentRef: DocumentReference
    
    init(username: String, uuid: String, dogs: [Dog] = [], walks: [Walk] = [], favoriteParks: [Park] = [], documentRef: DocumentReference) {
        self.username = username
        self.uuid = uuid
        self.dogs = dogs
        self.walks = walks
        self.favoriteParks = favoriteParks
        self.documentRef = documentRef
    }
}

extension DBFUser {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let username = jsonDictionary[Keys.User.username] as? String,
            let dogsArray = jsonDictionary[Keys.User.dogs] as? [[String: Any]],
            let uuid = jsonDictionary[Keys.User.uuid] as? String,
            let walksArray = jsonDictionary[Keys.User.walks] as? [[String: Any]],
            let favoriteParksArray = jsonDictionary[Keys.User.favoriteParks] as? [[String: Any]],
            let documentRef = jsonDictionary[Keys.User.documentRef] as? DocumentReference
            else { return nil }
        
        let dogs = dogsArray.compactMap { Dog(jsonDictionary: $0) }
        let walks = walksArray.compactMap { Walk(jsonDictionary: $0) }
        let favoriteParks = favoriteParksArray.compactMap { Park(jsonDictionary: $0) }
        
        self.init(username: username, uuid: uuid, dogs: dogs, walks: walks, favoriteParks: favoriteParks, documentRef: documentRef)
    }
    
    var asDictionary: [String: Any] {
        let dogsAsDictionaries = self.dogs.map { $0.asDictionary }
        let walksAsDictionaries = self.walks.map { $0.asDictionary }
        let favoriteParksAsDictionaries = self.favoriteParks.map { $0.asDictionary }
        return [Keys.User.username: self.username,
                Keys.User.uuid: self.uuid,
                Keys.User.dogs: dogsAsDictionaries,
                Keys.User.walks: walksAsDictionaries,
                Keys.User.favoriteParks: favoriteParksAsDictionaries,
                Keys.User.documentRef: self.documentRef]
    }
    
    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asDictionary, options: .prettyPrinted)
    }
}
