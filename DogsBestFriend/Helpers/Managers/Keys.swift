//
//  Keys.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/17/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct Keys {

    struct Dog {
        static let type = "dog"
        static let name = "name"
        static let birthdate = "birthdate"
        static let adoptionDate = "adoptionDate"
        static let microchipID = "microchipId"
        static let breed = "breed"
        static let color = "color"
        static let registration = "registration"
        static let profileImageAsData = "profileImageAsData"
        static let medicalHistory = "medicalHistory"
    }
    
    struct MedicalRecord {
        static let type = "medicalRecord"
        static let name = "name"
        static let date = "date"
        static let note = "note"
    }

    struct Park {
        static let type = "park"
        static let placemark = "placemark"
        static let isFavorite = "isFavorite"
    }

    struct Walk {
        static let type = "walk"
        static let date = "date"
    }
}