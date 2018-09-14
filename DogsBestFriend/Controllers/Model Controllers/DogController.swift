//
//  DogController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/14/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class DogControler {
    // MARK: - Shared Instance
    
    static let shared = DogControler()
    
    // MARK: - Properties
    
    var dogs: [Dog] = []
    
    // MARK: - CRUD Functions
    
    func addDogWith(name: String, birthdate: Date, adoptionDate: Date, microchipID: String, breed: String, color: String, registration: String) {
        let newDog = Dog(name: name, birthdate: birthdate, adoptionDate: adoptionDate, microchipID: microchipID, breed: breed, color: color, registration: registration)
        dogs.append(newDog)
        
        //TODO: API Persistence
    }
    
    func updateDog(_ dog: Dog, withName name: String, birthdate: Date, adoptionDate: Date, microchipID: String, breed: String, color: String, registration: String) {
        dog.name = name
        dog.birthdate = birthdate
        dog.adoptionDate = adoptionDate
        dog.microchipID = microchipID
        dog.breed = breed
        dog.color = color
        dog.registration = registration
        
        // TODO: API Persistence
    }
    
    func deleteDog(_ dog: Dog) {
        guard let index = dogs.index(of: dog) else { return }
        dogs.remove(at: index)
        
        //TODO: API Persistence
    }
    
}
