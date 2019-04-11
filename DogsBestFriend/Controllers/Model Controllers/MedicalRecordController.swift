//
//  MedicalController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class MedicalRecordController {
    // MARK: - Shared Instance
    
    static let shared = MedicalRecordController()
    
    // MARK: - CRUD Functions
    func addMedicalRecordTo(dog: Dog, name: String, date: Date, note: String, completion: @escaping (Bool) -> Void) {
        let newMedical = MedicalRecord(name: name, date: date, note: note)
        DogController.shared.addMedicalTo(dog: dog, medical: newMedical, completion: completion)
    }
    
    func delete(medicalRecord: MedicalRecord, fromDog dog: Dog, completion: @escaping (Bool) -> Void) {
        guard let index = dog.medicalHistory.firstIndex(of: medicalRecord) else { return }
        dog.medicalHistory.remove(at: index)
        
        DogController.shared.updateDog(dog, withName: dog.name,
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
}
