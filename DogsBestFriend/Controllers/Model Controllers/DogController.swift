//
//  DogController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class DogController {
    // MARK: - Shared Instance

    static let shared = DogController()

    // MARK: - Properties

    var dogs: [Dog] = []

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
        
        let newDog = Dog(name: name,
                         birthdate: birthdate,
                         adoptionDate: adoptionDate,
                         microchipID: microchipID,
                         breed: breed,
                         color: color,
                         registration: registration,
                         profileImageAsData: profileImageAsData,
                         medicalHistory: medicalHistory)
        

        // TODO: NEEDS TO BE REMOVED ONCE DATABASE IS SET UP
        dogs.append(newDog)
        completion(true)
        // BOTTOM OF MOVED DATA
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = newDog.asData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error adding dog to database: %@", error.localizedDescription)
                completion(false)
                return
            }
            
            self.dogs.append(newDog)
            completion(true)
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
                  profileImageAsData: dog.profileImageAsData,
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
                   medicalHistory: [MedicalRecord],
                   completion: @escaping (Bool) -> Void) {
        
        dog.name = name
        dog.birthdate = birthdate
        dog.adoptionDate = adoptionDate
        dog.microchipID = microchipID
        dog.breed = breed
        dog.color = color
        dog.registration = registration
        dog.medicalHistory = medicalHistory
        
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.httpBody = dog.asData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error updating %@: %@", [dog.name, error.localizedDescription])
                completion(false)
                return
            }
            
            guard let _ = data else {
                NSLog("Error converting updated data for \(dog.name)")
                completion(false)
                return
            }
            completion(true)
        }.resume()
    }

    func deleteDog(_ dog: Dog, completion: @escaping (Bool) -> Void) {
        // MARK: - TO DELETE AFTER API FINISHED
        if let index = self.dogs.firstIndex(of: dog) {
            self.dogs.remove(at: index)
            completion(true)
            return
        }
        completion(false)
        let url = Private.baseURL!
        
        var request = URLRequest(url: url)
        request.httpMethod = "DEL"
        request.httpBody = dog.asData
        
        URLSession.shared.dataTask(with: request) { (data, _, error) in
            if let error = error {
                NSLog("Error deleting dog from database: %@", [dog.name, error.localizedDescription])
                completion(false)
                return
            }
            
            if let index = self.dogs.firstIndex(of: dog) {
                self.dogs.remove(at: index)
                completion(true)
                return
            }
            
            NSLog("Error deleting %@ from local controller", dog.name)
            completion(false)
        }.resume()
    }
}
