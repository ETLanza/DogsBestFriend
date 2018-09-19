//
//  Medical.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/18/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

class MedicalRecord: Codable, Equatable {
    
    enum CodingKeys: String, CodingKey {
        case name
        case date
        case note
    }
    
    var name: String
    var date: Date
    var note: String?
    
    init(name: String, date: Date, note: String?) {
        self.name = name
        self.date = date
        self.note = note
    }
    
    static func == (lhs: MedicalRecord, rhs: MedicalRecord) -> Bool {
        return lhs.name == rhs.name && lhs.date == rhs.date && lhs.note == rhs.note
    }
}

extension MedicalRecord {
    convenience init?(jsonDictionary: [String: Any]) {
        guard let name = jsonDictionary[Keys.MedicalRecord.name] as? String,
            let date = jsonDictionary[Keys.MedicalRecord.date] as? Date,
            let note = jsonDictionary[Keys.MedicalRecord.note] as? String
            else { return nil }
        self.init(name: name, date: date, note: note)
    }
    
    var asDictionary: [String: Any] {
        return [Keys.MedicalRecord.name: self.name,
        Keys.MedicalRecord.date: self.date,
        Keys.MedicalRecord.note: self.note ?? ""]
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
