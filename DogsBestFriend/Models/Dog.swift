//
//  Dog.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class Dog: Equatable, Codable {
    
    var name: String
    var birthdate: Date
    var adoptionDate: Date
    var microchipID: String?
    var breed: String?
    var color: String?
    var registration: String?
    // var medicalHistory: [Medical] = []
    
    init(name: String, birthdate: Date, adoptionDate: Date, microchipID: String, breed: String, color: String, registration: String) {
        self.name = name
        self.birthdate = birthdate
        self.adoptionDate = adoptionDate
        self.microchipID = microchipID
        self.breed = breed
        self.color = color
        self.registration = registration
    }
    
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.name == rhs.name && lhs.birthdate == rhs.birthdate && lhs.adoptionDate == rhs.adoptionDate && lhs.microchipID == rhs.microchipID && lhs.breed == rhs.breed && lhs.color == rhs.color && lhs.registration == rhs.registration
    }
}
