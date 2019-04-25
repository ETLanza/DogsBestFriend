//
//  Park.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class Park: Equatable {
    
    var isFavorite: Bool
    var name: String
    var address: String
    var latitude: Double
    var longitude: Double
    var documentRef: DocumentReference?
    var ownerDocumentRef: DocumentReference?
    var uuid: String?
    
    var placemark: MKPlacemark {
        return MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
    }
    
    init(name: String, address: String, latitude: Double, longitude: Double, isFavorite: Bool = false) {
        self.name = name
        self.address = address
        self.latitude = latitude
        self.longitude = longitude
        self.isFavorite = isFavorite
    }
    
    // MARK: Equatable
    
    static func == (lhs: Park, rhs: Park) -> Bool {
        return lhs.name == rhs.name && lhs.address == rhs.address
    }
}

extension Park {
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[Keys.Park.name] as? String,
            let address = dictionary[Keys.Park.address] as? String,
            let latitude = dictionary[Keys.Park.latitude] as? Double,
            let longitude = dictionary[Keys.Park.longitude] as? Double,
            let isFavorite = dictionary[Keys.Park.isFavorite] as? Bool
            else { return nil }
        self.init(name: name, address: address, latitude: latitude, longitude: longitude, isFavorite: isFavorite)
    }
    
    convenience init?(favoriteDictionary: [String: Any]) {
        guard let name = favoriteDictionary[Keys.Park.name] as? String,
            let address = favoriteDictionary[Keys.Park.address] as? String,
            let latitude = favoriteDictionary[Keys.Park.latitude] as? Double,
            let longitude = favoriteDictionary[Keys.Park.longitude] as? Double,
            let isFavorite = favoriteDictionary[Keys.Park.isFavorite] as? Bool,
            let documentRef = favoriteDictionary[Keys.Park.documentRef] as? DocumentReference,
            let ownerDocumentRef = favoriteDictionary[Keys.Park.ownerDocumentRef] as? DocumentReference,
            let uuid = favoriteDictionary[Keys.Park.uuid] as? String
            else { return nil }
        
        self.init(name: name, address: address, latitude: latitude, longitude: longitude, isFavorite: isFavorite)
        
        self.documentRef = documentRef
        self.ownerDocumentRef = ownerDocumentRef
        self.uuid = uuid
    }
    
    var asDictionary: [String: Any] {
        return [Keys.Park.name: self.name,
                Keys.Park.address: self.address,
                Keys.Park.latitude: self.latitude,
                Keys.Park.longitude: self.longitude,
                Keys.Park.isFavorite: self.isFavorite]
    }
    
    var asFavoritedDictionary: [String: Any] {
        var dictionary: [String:Any] = [Keys.Park.name: self.name,
                                        Keys.Park.address: self.address,
                                        Keys.Park.latitude: self.latitude,
                                        Keys.Park.longitude: self.longitude,
                                        Keys.Park.isFavorite: self.isFavorite]
        
        if let documentRef = self.documentRef {
            dictionary[Keys.Park.documentRef] = documentRef
        }
        
        if let ownerDocumentRef = self.ownerDocumentRef {
            dictionary[Keys.Park.ownerDocumentRef] = ownerDocumentRef
        }
        
        if let uuid = uuid {
            dictionary[Keys.Park.uuid] = uuid
        }
        
        return dictionary
    }
    
    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asDictionary, options: .prettyPrinted)
    }
    
    var asFavoritedData: Data? {
        return try? JSONSerialization.data(withJSONObject: asFavoritedDictionary, options: .prettyPrinted)
    }
}

extension Park: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(self.name.hashValue)
        hasher.combine(self.address.hashValue)
    }
}

