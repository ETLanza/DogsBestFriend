//
//  ParkController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import MapKit
import Firebase

class ParkController {
    // MARK: - Shared Instance

    static let shared = ParkController()
    

    // MARK: - Properties
    let dbRef = Firestore.firestore().collection("parks")
    fileprivate var filterLocation: CLLocation? = LocationManager.shared.location
    var parksSet: Set<Park> = [] {
        didSet {
            var array = Array(parksSet)
            
            if let filterLocation = filterLocation {
                array = array.filter( { return $0.placemark.location!.distance(from: filterLocation) < 50000.00 })
                
                array.sort { (parkA, parkB) -> Bool in
                    return parkA.placemark.location!.distance(from: filterLocation) < parkB.placemark.location!.distance(from: filterLocation)
                }
            }
            
            parks = array
        }
    }
    var parks: [Park] = []
    
    // MARK: - CRUD Functions
    
    func addParkWith(placemark: MKPlacemark) {
        let address = AddressFormatter.shared.parseAddress(selectedItem: placemark)
        let newPark = Park(name: placemark.name ?? "Unknown Park", address: address, latitude: placemark.coordinate.latitude, longitude: placemark.coordinate.longitude)
        parksSet.formUnion([newPark])
    }

    func addFavorite(park: Park, toUser user: DBFUser = DBFUserController.shared.loggedInUser, completion: @escaping (Bool) -> Void) {
        
        let documentRef = dbRef.document()
        park.documentRef = documentRef
        park.ownerDocumentRef = user.documentRef
        park.uuid = documentRef.documentID
        
        
        documentRef.setData(park.asFavoritedDictionary) { (error) in
            if let error = error {
                print("Error saving \(park.name) to firebase : \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            user.favoriteParkReferences.append(documentRef)
            user.favoriteParks.append(park)
            
            DBFUserController.shared.saveLoggedInUser(completion: completion)
        }
    }

    func removeFavorite(park: Park, fromUser user: DBFUser = DBFUserController.shared.loggedInUser, completion: @escaping (Bool) -> Void) {
        DBFUserController.shared.remove(park: park) { (success) in
            if success {
                park.documentRef?.delete(completion: { (error) in
                    if let error = error {
                        print("Error deleting \(park.name)'s : \(error) : \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    completion(true)
                })
            }
        }
    }
    
    func fetchFavoriteParksFor(dbfUser: DBFUser, completion: @escaping (Bool) -> Void) {
        let dg = DispatchGroup()
        dbfUser.favoriteParkReferences.forEach { (documentRef) in
            dg.enter()
            documentRef.getDocument(completion: { (snapshot, error) in
                if let error = error {
                    print("Error fetching park for \(dbfUser.username) : \(error) : \(error.localizedDescription)")
                    dg.leave()
                    return
                }
                
                guard let favoriteParkDict = snapshot?.data() else {
                    print("Error turning \(snapshot!.documentID) snapshot into favorite park dictionary")
                    dg.leave()
                    return
                }
                
                guard let newPark = Park(favoriteDictionary: favoriteParkDict) else {
                    print("Error with favorite park dictionary init")
                    dg.leave()
                    return
                }
                
                dbfUser.favoriteParks.append(newPark)
                dg.leave()
            })
        }
        dg.notify(queue: .main) {
            self.parksSet.formUnion(dbfUser.favoriteParks)
            completion(true)
        }
    }

    func removeAllNonFavoriteParks() {
        parksSet.removeAll()
        parksSet.formUnion(DBFUserController.shared.loggedInUser.favoriteParks)
    }
    
    func changeFilterLocationTo(_ location: CLLocation) {
        filterLocation = location
    }
}
