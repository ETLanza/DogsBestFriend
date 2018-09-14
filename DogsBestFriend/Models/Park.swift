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
        return lhs.placemark == rhs.placemark
    }
}
