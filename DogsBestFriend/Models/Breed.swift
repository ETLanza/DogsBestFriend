//
//  Breed.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 7/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit

struct Breed: Codable {
    
    let name: String
    let breedImageGetterAsString: String
    
    init?(name: String, breedImageGetterAsString: String) {
        self.name = name
        self.breedImageGetterAsString = breedImageGetterAsString
    }
}
