//
//  DisplayFormatter.swift
//  DogsBestFriend
//
//  Created by Eric Lanza on 9/19/18.
//  Copyright © 2018 ETLanza. All rights reserved.
//

import Foundation

struct DisplayFormatter {
    static func distance(_ distance: Double) -> String {
        let distanceMeasurement = Measurement(value: distance, unit: UnitLength.meters)
        return DisplayFormatter.distance(distanceMeasurement)
    }

    static func distance(_ distance: Measurement<UnitLength>) -> String {
        let formatter = MeasurementFormatter()
        return formatter.string(from: distance)
    }

    static func time(_ seconds: Int) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: TimeInterval(seconds))!
    }

    static func stringFrom(date: Date?) -> String {
        guard let date = date as Date? else { return "" }
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.string(from: date)
    }
    
    static func dateFrom(string: String) -> Date {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        return formatter.date(from: string)!
    }

    static func dayOfTheWeek(_ timestamp: Date?) -> String {
        guard let timestamp = timestamp as Date? else { return "" }
        let formatter = DateFormatter()
        let day = formatter.weekdaySymbols[Calendar.current.component(.weekday, from: timestamp)]
        return "\(day)"
    }
}
