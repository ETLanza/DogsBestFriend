//
//  Dog.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class Dog: Equatable, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case birthdate
        case adoptionDate
        case microchipID
        case breed
        case color
        case registration
        case profileImageAsData
        case medicalHistory
    }
    
    var name: String
    var birthdate: Date
    var adoptionDate: Date
    var microchipID: String?
    var breed: String?
    var color: String?
    var registration: String?
    var profileImageAsData: Data
    var medicalHistory: [MedicalRecord] = []
    
    init(name: String, birthdate: Date, adoptionDate: Date, microchipID: String?, breed: String?, color: String?, registration: String?, profileImageAsData: Data, medicalHistory: [MedicalRecord] = []) {
        self.name = name
        self.birthdate = birthdate
        self.adoptionDate = adoptionDate
        self.microchipID = microchipID
        self.breed = breed
        self.color = color
        self.registration = registration
        self.profileImageAsData = profileImageAsData
        self.medicalHistory = medicalHistory
    }
    
    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.name == rhs.name && lhs.birthdate == rhs.birthdate && lhs.adoptionDate == rhs.adoptionDate && lhs.microchipID == rhs.microchipID && lhs.breed == rhs.breed && lhs.color == rhs.color && lhs.registration == rhs.registration
    }
}

extension Dog {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let name = jsonDictionary[Keys.Dog.name] as? String,
            let birthDate = jsonDictionary[Keys.Dog.birthdate] as? Date,
            let adoptionDate = jsonDictionary[Keys.Dog.adoptionDate] as? Date,
            let microchipID = jsonDictionary[Keys.Dog.microchipID] as? String,
            let breed = jsonDictionary[Keys.Dog.breed] as? String,
            let color = jsonDictionary[Keys.Dog.color] as? String,
            let registration = jsonDictionary[Keys.Dog.registration] as? String,
            let profileImageAsData = jsonDictionary[Keys.Dog.profileImageAsData] as? Data,
            let medicalHistory = jsonDictionary[Keys.Dog.medicalHistory] as? [MedicalRecord]
            else { return nil }
        
        self.init(name: name,
                  birthdate: birthDate,
                  adoptionDate: adoptionDate,
                  microchipID: microchipID,
                  breed: breed, color: color,
                  registration: registration,
                  profileImageAsData: profileImageAsData,
                  medicalHistory: medicalHistory)
    }
    
    var asJSONDictionary: [String: Any] {
        return [Keys.Dog.name: self.name,
                Keys.Dog.birthdate: self.birthdate,
                Keys.Dog.adoptionDate: self.adoptionDate,
                Keys.Dog.microchipID: self.microchipID ?? "",
                Keys.Dog.breed: self.breed ?? "",
                Keys.Dog.color: self.color ?? "",
                Keys.Dog.registration: self.registration ?? "",
                Keys.Dog.profileImageAsData: self.profileImageAsData,
                Keys.Dog.medicalHistory: self.medicalHistory]
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
