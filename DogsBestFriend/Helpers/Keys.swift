//
//  Keys.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/17/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct Keys {
    
    struct User {
        static let type = "user"
        static let username = "username"
        static let uuid = "uuid"
        static let dogs = "dogs"
        static let walks = "walks"
        static let favoriteParks = "favoriteParks"
        static let documentRef = "documentRef"
    }

    struct Dog {
        static let type = "dog"
        static let name = "name"
        static let birthdate = "birthdate"
        static let birthdateAsString = "birthdateAsString"
        static let adoptionDate = "adoptionDate"
        static let adoptionDateAsString = "adoptionDateAsString"
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
        static let dateAsString = "dateAsString"
        static let note = "note"
    }

    struct Park {
        static let type = "park"
        static let name = "name"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let placemark = "placemark"
        static let isFavorite = "isFavorite"
    }

    struct Walk {
        static let type = "walk"
        static let distance = "distance"
        static let timestamp = "timestamp"
        static let duration = "duration"
        static let locations = "locations"
    }
    
    struct Location {
        static let type = "location"
        static let latitude = "latitude"
        static let longitude = "longitude"
        static let timestamp = "timestamp"
    }
}
