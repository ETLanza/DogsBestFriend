//
//  MedicalController.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation
import Firebase

class MedicalRecordController {
    // MARK: - Shared Instance
    
    static let shared = MedicalRecordController()
    
    let db = Firestore.firestore().collection("dogs")
    
    // MARK: - CRUD Functions
    func addMedicalRecordTo(dog: Dog, name: String, date: Date, note: String, completion: @escaping (Bool) -> Void) {
        let newMedical = MedicalRecord(name: name, date: date, note: note)
        DogController.shared.addMedicalTo(dog: dog, medical: newMedical, completion: completion)
    }
    
    func delete(medicalRecord: MedicalRecord, fromDog dog: Dog, completion: @escaping (Bool) -> Void) {
        guard let index = dog.medicalHistory.firstIndex(of: medicalRecord) else { return }
        dog.medicalHistory.remove(at: index)
        
        dog.documentRef.setData(dog.asDictionary, mergeFields: [Keys.Dog.medicalHistory]) { (error) in
            if let error = error {
                print("Error deleting \(medicalRecord.name) from \(dog.name) : \(error) : \(error.localizedDescription)")
                completion(false)
                return
            } else {
                completion(true)
            }
        }
    }
}
