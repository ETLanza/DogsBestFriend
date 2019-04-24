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
    var dogReferences: [DocumentReference]
    var walks: [Walk]
    var walkReferences: [DocumentReference]
    var favoriteParks: [Park]
    var favoriteParkReferences: [DocumentReference]
    var documentRef: DocumentReference
    
    init(username: String, uuid: String, dogs: [Dog] = [], dogReferences: [DocumentReference] = [], walks: [Walk] = [], walkReferences: [DocumentReference] = [], walk favoriteParks: [Park] = [], favoriteParkReferences: [DocumentReference] = [], documentRef: DocumentReference) {
        self.username = username
        self.uuid = uuid
        self.dogs = dogs
        self.dogReferences = dogReferences
        self.walks = walks
        self.walkReferences = walkReferences
        self.favoriteParks = favoriteParks
        self.favoriteParkReferences = favoriteParkReferences
        self.documentRef = documentRef
    }
}

extension DBFUser {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let username = jsonDictionary[Keys.User.username] as? String,
            let dogReferences = jsonDictionary[Keys.User.dogReferences] as? [DocumentReference],
            let walkReferences = jsonDictionary[Keys.User.walkReferences] as? [DocumentReference],
            let favoriteParkReferences = jsonDictionary[Keys.User.favoriteParkReferences] as? [DocumentReference],
            let uuid = jsonDictionary[Keys.User.uuid] as? String,
            let documentRef = jsonDictionary[Keys.User.documentRef] as? DocumentReference
            else { return nil }
        
        self.init(username: username, uuid: uuid, dogReferences: dogReferences, walkReferences: walkReferences, favoriteParkReferences: favoriteParkReferences, documentRef: documentRef)
    }
    
    var asDictionary: [String: Any] {
        return [Keys.User.username: self.username,
                Keys.User.uuid: self.uuid,
                Keys.User.dogReferences: self.dogReferences,
                Keys.User.walkReferences: self.walkReferences,
                Keys.User.favoriteParkReferences: self.favoriteParkReferences,
                Keys.User.documentRef: self.documentRef]
    }
    
    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asDictionary, options: .prettyPrinted)
    }
}
