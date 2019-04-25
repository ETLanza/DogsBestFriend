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
        case uuid
    }
    
    var name: String
    var date: Date
    var uuid: String
    var dateAsString: String {
        return DisplayFormatter.stringFrom(date: date)
    }
    var note: String?
    
    init(name: String, date: Date, note: String?, uuid: String = UUID().uuidString) {
        self.name = name
        self.date = date
        self.note = note
        self.uuid = uuid
    }
    
    static func == (lhs: MedicalRecord, rhs: MedicalRecord) -> Bool {
        return lhs.uuid == rhs.uuid
    }
}

extension MedicalRecord {
    convenience init?(dictionary: [String: Any]) {
        guard let name = dictionary[Keys.MedicalRecord.name] as? String,
            let dateAsString = dictionary[Keys.MedicalRecord.dateAsString] as? String,
            let note = dictionary[Keys.MedicalRecord.note] as? String,
            let uuid = dictionary[Keys.MedicalRecord.uuid] as? String
            else { return nil }
        
        let date = DisplayFormatter.dateFrom(string: dateAsString)
        self.init(name: name, date: date, note: note, uuid: uuid)
    }
    
    var asDictionary: [String: Any] {
        return [Keys.MedicalRecord.name: self.name,
                Keys.MedicalRecord.dateAsString: self.dateAsString,
                Keys.MedicalRecord.note: self.note ?? "",
                Keys.MedicalRecord.uuid: self.uuid]
    }
    
    var asData: Data? {
        let encoder = JSONEncoder()
        return try? encoder.encode(self)
    }
}
