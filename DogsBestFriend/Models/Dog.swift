//
//  Dog.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import UIKit
import Firebase

class Dog: Equatable {

    var name: String
    var birthdate: Date
    var birthdateAsString: String {
        return DisplayFormatter.stringFrom(date: birthdate)
    }
    var adoptionDate: Date
    var adoptionDateAsString: String {
        return DisplayFormatter.stringFrom(date: adoptionDate)
    }
    var microchipID: String?
    var breed: String?
    var color: String?
    var registration: String?
    var profileImageAsData: Data?
    var profileImage: UIImage? {
        guard let profileImageAsData = profileImageAsData else { return nil }
        return UIImage(data: profileImageAsData)
    }
    var profileImageStorageRefPath: String
    var medicalHistory: [MedicalRecord] = []
    var documentRef: DocumentReference
    var ownerDocumentRef: DocumentReference
    var uuid: String

    init(name: String, birthdate: Date, adoptionDate: Date, microchipID: String? = nil, breed: String? = nil, color: String? = nil, registration: String? = nil, profileImageAsData: Data? = UIImage(named: "coolDog")!.pngData(), profileImageStorageRefPath: String, medicalHistory: [MedicalRecord] = [], documentRef: DocumentReference, ownerDocumentRef: DocumentReference) {
        
        self.name = name
        self.birthdate = birthdate
        self.adoptionDate = adoptionDate
        self.microchipID = microchipID
        self.breed = breed
        self.color = color
        self.registration = registration
        self.profileImageAsData = profileImageAsData
        self.profileImageStorageRefPath = profileImageStorageRefPath
        self.medicalHistory = medicalHistory
        self.documentRef = documentRef
        self.ownerDocumentRef = ownerDocumentRef
        self.uuid = documentRef.documentID
    }

    static func == (lhs: Dog, rhs: Dog) -> Bool {
        return lhs.name == rhs.name && lhs.birthdate == rhs.birthdate && lhs.adoptionDate == rhs.adoptionDate && lhs.microchipID == rhs.microchipID && lhs.breed == rhs.breed && lhs.color == rhs.color && lhs.registration == rhs.registration
    }
}

extension Dog {
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[Keys.Dog.name] as? String,
            let birthdateAsString = dictionary[Keys.Dog.birthdateAsString] as? String,
            let adoptionDateAsString = dictionary[Keys.Dog.adoptionDateAsString] as? String,
            let microchipID = dictionary[Keys.Dog.microchipID] as? String,
            let breed = dictionary[Keys.Dog.breed] as? String,
            let color = dictionary[Keys.Dog.color] as? String,
            let registration = dictionary[Keys.Dog.registration] as? String,
            let profileImageStorageRefPath = dictionary[Keys.Dog.profileImageStorageRefPath] as? String,
            let medicalHistoryArray = dictionary[Keys.Dog.medicalHistory] as? [String:[String: Any]],
            let documentRef = dictionary[Keys.Dog.documentRef] as? DocumentReference,
            let ownerDocumentRef = dictionary[Keys.Dog.ownerDocumentRef] as? DocumentReference
            else { return nil }
        
        let birthdate = DisplayFormatter.dateFrom(string: birthdateAsString)
        let adoptionDate = DisplayFormatter.dateFrom(string: adoptionDateAsString)

        let medicalHistory = medicalHistoryArray.compactMap { MedicalRecord(dictionary: $0.value) }

        self.init(name: name,
                  birthdate: birthdate,
                  adoptionDate: adoptionDate,
                  microchipID: microchipID,
                  breed: breed, color: color,
                  registration: registration,
                  profileImageStorageRefPath: profileImageStorageRefPath,
                  medicalHistory: medicalHistory,
                  documentRef: documentRef,
                  ownerDocumentRef: ownerDocumentRef)
    }

    var asDictionary: [String: Any] {
        
        var medicalHistoryAsDictionaries: [String: [String:Any]] = [:]
        self.medicalHistory.forEach { (record) in
            medicalHistoryAsDictionaries[record.uuid] = record.asDictionary
        }
        
        return [Keys.Dog.name: self.name,
                Keys.Dog.birthdateAsString: self.birthdateAsString,
                Keys.Dog.adoptionDateAsString: self.adoptionDateAsString,
                Keys.Dog.microchipID: self.microchipID ?? "",
                Keys.Dog.breed: self.breed ?? "",
                Keys.Dog.color: self.color ?? "",
                Keys.Dog.registration: self.registration ?? "",
                Keys.Dog.medicalHistory: medicalHistoryAsDictionaries,
                Keys.Dog.documentRef: self.documentRef,
                Keys.Dog.profileImageStorageRefPath: self.profileImageStorageRefPath,
                Keys.Dog.ownerDocumentRef: self.ownerDocumentRef]
    }
}
