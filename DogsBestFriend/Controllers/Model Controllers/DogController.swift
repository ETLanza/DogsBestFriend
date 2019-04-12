//
//  DogController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase

class DogController {
    // MARK: - Shared Instance

    static let shared = DogController()

    // MARK: - Properties

    var dogs: [Dog] = []
    let storageRef = Storage.storage().reference().child("dogs")
    let dbRef = Firestore.firestore().collection("dogs")

    // MARK: - CRUD Functions

    func addDogWith(name: String,
                    birthdate: Date,
                    adoptionDate: Date,
                    microchipID: String?,
                    breed: String?,
                    color: String?,
                    registration: String?,
                    profileImageAsData: Data,
                    medicalHistory: [MedicalRecord],
                    completion: @escaping (Bool) -> Void) {
        
        let documentRef = dbRef.document()
        let profileImageStorageRef = storageRef.child(documentRef.documentID)
        profileImageStorageRef.putData(profileImageAsData)
        let profileImageStorageRefPath = profileImageStorageRef.name
        let ownerDocumentRef = UserController.shared.loggedInUser!.documentRef
        
        
        let newDog = Dog(name: name,
                         birthdate: birthdate,
                         adoptionDate: adoptionDate,
                         microchipID: microchipID,
                         breed: breed,
                         color: color,
                         registration: registration,
                         profileImageAsData: profileImageAsData,
                         profileImageStorageRefPath: profileImageStorageRefPath,
                         medicalHistory: medicalHistory,
                         documentRef: documentRef,
                         ownerDocumentRef: ownerDocumentRef)

        saveDogToFirebase(newDog) { (success) in
            if success {
                UserController.shared.add(dog: newDog, completion: { (success) in
                    if success {
                        UserController.shared.saveLoggedInUser(completion: completion)
                    } else {
                        completion(false)
                    }
                })
            } else {
                completion(false)
            }
        }
    }

    func addMedicalTo(dog: Dog,
                      medical: MedicalRecord,
                      completion: @escaping (Bool) -> Void) {
        
        dog.medicalHistory.append(medical)
        updateDog(dog, withName: dog.name,
                  birthdate: dog.birthdate,
                  adoptionDate: dog.adoptionDate,
                  microchipID: dog.microchipID,
                  breed: dog.breed,
                  color: dog.color,
                  registration: dog.registration,
                  profileImageAsData: dog.profileImageAsData!,
                  medicalHistory: dog.medicalHistory,
                  completion: completion)        
    }

    func updateDog(_ dog: Dog,
                   withName name: String,
                   birthdate: Date,
                   adoptionDate: Date,
                   microchipID: String?,
                   breed: String?,
                   color: String?,
                   registration: String?,
                   profileImageAsData: Data,
                   profileImageStorageRef: StorageReference? = nil,
                   medicalHistory: [MedicalRecord],
                   documentRef: DocumentReference? = nil,
                   completion: @escaping (Bool) -> Void) {
        
        dog.name = name
        dog.birthdate = birthdate
        dog.adoptionDate = adoptionDate
        dog.microchipID = microchipID
        dog.breed = breed
        dog.color = color
        dog.registration = registration
        dog.profileImageAsData = profileImageAsData
        dog.medicalHistory = medicalHistory
        
        UserController.shared.saveLoggedInUser(completion: completion)
    }
    
    func saveDogToFirebase(_ dog: Dog, completion: @escaping (Bool) -> Void) {
        dog.documentRef.setData(dog.asDictionary) { (error) in
            if let error = error {
                print("Error saving dog \(dog.name) : \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            completion(true)
        }
    }

    func deleteDog(_ dog: Dog, completion: @escaping (Bool) -> Void) {
        UserController.shared.remove(dog: dog) { (success) in
            if success {
                self.storageRef.child(dog.profileImageStorageRefPath).delete(completion: { (error) in
                    if let error = error {
                        print("Error deleting \(dog.name)'s profile image from storage : \(error) : \(error.localizedDescription)")
                        completion(false)
                        return
                    }
                    
                    dog.documentRef.delete(completion: { (error) in
                        if let error = error {
                            print("Error deleting \(dog.name)'s profile image from storage : \(error) : \(error.localizedDescription)")
                            completion(false)
                            return
                        }
                        completion(true)
                    })
                })
            }
        }
    }
    
    func fetchDogsFor(dbfUser: DBFUser, completion: @escaping (Bool) -> Void) {
        let dg = DispatchGroup()
        dbfUser.dogReferences.forEach { (documentRef) in
            dg.enter()
            documentRef.getDocument(completion: { (documentSnapshot, error) in
                if let error = error {
                    
                    print("Error getting dog document at \(documentRef.path): \(error) : \(error.localizedDescription)")
                    completion(false)
                    dg.leave()
                    return
                }
                
                guard let snapshotAsDict = documentSnapshot?.data() else { completion(false); dg.leave(); return }
                
                if let dog = Dog(jsonDictionary: snapshotAsDict) {
                    self.fetchImageFor(dog: dog, completion: { (success) in
                        if success {
                            dbfUser.dogs.append(dog)
                            dg.leave()
                        }
                    })
                }
            })
        }
        dg.notify(queue: .main, execute: {
             completion(true)
        })
    }
    
    func fetchImageFor(dog: Dog, completion: @escaping (Bool) -> Void) {
        
        storageRef.child(dog.profileImageStorageRefPath).getData(maxSize: 30 * 1024 * 1024) { (data, error) in
            if let error = error {
                print("Error fetching profile image data for \(dog.name) : \(error) : \(error.localizedDescription)")
                completion(false)
                return
            }
            
            guard let data = data else { completion(false); return }
            
            dog.profileImageAsData = data
            completion(true)
        }
    }
}
