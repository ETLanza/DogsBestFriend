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

    init(username: String) {
        self.username = username
        self.dogs = []
        self.walks = []
        self.favoriteParks = []
    }
}
