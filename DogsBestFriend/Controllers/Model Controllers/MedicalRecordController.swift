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
        
    }
    
    func update(medicalRecord: MedicalRecord, name: String, date: Date, note: String, completion: @escaping (Bool) -> Void) {
        
    }
    
    func delete(medicalRecord: MedicalRecord, completion: @escaping (Bool) -> Void) {
        
    }
}