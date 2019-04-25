//
//  Walk.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase

class Walk: Equatable {
    
    var distance: Double
    var timestamp: Date
    var duration: Int
    var locations: [Location]
    var documentRef: DocumentReference
    var ownerDocumentRef: DocumentReference
    var uuid: String
    
    init(distance: Double, timestamp: Date, duration: Int, locations: [Location] = [], documentRef: DocumentReference, ownerDocumentRef: DocumentReference) {
        self.distance = distance
        self.timestamp = timestamp
        self.duration = duration
        self.locations = locations
        self.documentRef = documentRef
        self.ownerDocumentRef = documentRef
        self.uuid = documentRef.documentID
    }
    
    static func == (lhs: Walk, rhs: Walk) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension Walk {
    convenience init?(dictionary: [String: Any]) {
        guard let distance = dictionary[Keys.Walk.distance] as? Double,
            let timestampAsDouble = dictionary[Keys.Walk.timestamp] as? TimeInterval,
            let duration = dictionary[Keys.Walk.duration] as? Int,
            let locationsArray = dictionary[Keys.Walk.locations] as? [String:[String: Any]],
            let documentRef = dictionary[Keys.Walk.documentRef] as? DocumentReference,
            let ownerDocumentRef = dictionary[Keys.Walk.ownerDocumentRef] as? DocumentReference
            else { return nil }
        
        let timestamp = Date(timeIntervalSince1970: timestampAsDouble)
        
        let locations: [Location] = locationsArray.compactMap( { Location(dictionary: $0.value) })
        
        self.init(distance: distance, timestamp: timestamp, duration: duration, locations: locations, documentRef: documentRef, ownerDocumentRef: ownerDocumentRef)
    }
    
    var asDictionary: [String: Any] {
        var locationsAsDictionaries: [String: [String:Any]] = [:]
        self.locations.forEach { (location) in
            locationsAsDictionaries[location.uuid] = location.asDictionary
        }
        return [Keys.Walk.distance: self.distance,
                Keys.Walk.timestamp: self.timestamp.timeIntervalSince1970,
                Keys.Walk.duration: self.duration,
                Keys.Walk.locations: locationsAsDictionaries,
                Keys.Walk.documentRef: self.documentRef,
                Keys.Walk.ownerDocumentRef: self.ownerDocumentRef,
                Keys.Walk.uuid: self.uuid]
    }
    
    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asDictionary, options: .prettyPrinted)
    }
}
