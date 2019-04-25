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
    
    let dbRef = Firestore.firestore().collection("parks")

    // MARK: - Properties
    var parksSet: Set<Park> = []
    var parks: [Park] {
        var array = Array(parksSet)
        
        array.sort { (parkA, parkB) -> Bool in
            return parkA.placemark.location!.distance(from: LocationManager.shared.location!) < parkB.placemark.location!.distance(from: LocationManager.shared.location!)
        }
        
        return array
    }
    
    // MARK: - CRUD Functions
    
    //TODO CONVERT TO FIREBASE

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
    
    
    
    
    //TODO: SEE IF THIS IS NEEDED, MIGHT BE OBSOLETE NOW
    func getPlacemarkFor(park: Park, completion: @escaping (MKPlacemark?)-> Void){
        let geocoder = CLGeocoder()
        var placemark = MKPlacemark()
        geocoder.reverseGeocodeLocation(CLLocation(latitude: park.latitude, longitude: park.longitude)) { (placemarks, error) in
            if let error = error {
                print("Error getting placemark for park: \(park.name) : \(error) : \(error.localizedDescription)")
                completion(nil)
                return
            }

            guard let newPlacemark = placemarks?.first else { completion(nil); return }

            placemark = MKPlacemark(placemark: newPlacemark)
            completion(placemark)
        }
    }
}
