//
//  Park.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import MapKit

class Park: Equatable {

    var placemark: MKPlacemark
    var isFavorite: Bool = false

    init(placemark: MKPlacemark) {
        self.placemark = placemark
    }

    // MARK: Equatable

    static func == (lhs: Park, rhs: Park) -> Bool {
        return lhs.placemark.name == rhs.placemark.name
    }
}

extension Park {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let placemark = jsonDictionary[Keys.Park.placemark] as? MKPlacemark,
            let isFavorite = jsonDictionary[Keys.Park.isFavorite] as? Bool
            else { return nil }
        self.init(placemark: placemark)
        self.isFavorite = isFavorite
    }

    var asJSONDictionary: [String: Any] {
        return [Keys.Park.placemark: self.placemark,
                Keys.Park.isFavorite: self.isFavorite]
    }

    var asData: Data? {
        return try? JSONSerialization.data(withJSONObject: asJSONDictionary, options: .prettyPrinted)
    }
}


