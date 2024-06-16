//
//  WeekDay.swift
//  Tracker
//
//  Created by Тася Галкина on 11.05.2024.
//

import Foundation

enum WeekDay: Int, Codable, CaseIterable {
    case monday = 0
    case tuesday = 1
    case wednesday = 2
    case thursday = 3
    case friday = 4
    case saturday = 5
    case sunday = 6
    
    var day: String {
        switch self {
        case .monday:
            return NSLocalizedString("Monday", comment: "")
        case .tuesday:
            return NSLocalizedString("Tuesday", comment: "")
        case .wednesday:
            return NSLocalizedString("Wednesday", comment: "")
        case .thursday:
            return NSLocalizedString("Thursday", comment: "")
        case .friday:
            return NSLocalizedString("Friday", comment: "")
        case .saturday:
            return NSLocalizedString("Saturday", comment: "")
        case .sunday:
            return NSLocalizedString("Sunday", comment: "")
        }
    }
    
    var shortDay: String {
        switch self {
        case .monday:
            return NSLocalizedString("Mon", comment: "")
        case .tuesday:
            return NSLocalizedString("Tue", comment: "")
        case .wednesday:
            return NSLocalizedString("Wed", comment: "")
        case .thursday:
            return NSLocalizedString("Thu", comment: "")
        case .friday:
            return NSLocalizedString("Fri", comment: "")
        case .saturday: 
            return NSLocalizedString("Sat", comment: "")
        case .sunday:
            return NSLocalizedString("Sun", comment: "")
        }
    }
    
    static func calculateScheduleValue(for schedule: [WeekDay]) -> Int16 {
        var scheduleValue: Int16 = 0
        for day in schedule {
            let dayRawValue = Int16 (1 << day.rawValue)
            scheduleValue |= dayRawValue
        }
        return scheduleValue
    }
    
   static func calculateScheduleArray(from value: Int16) -> [WeekDay] {
        var schedule: [WeekDay] = []
        for day in WeekDay.allCases {
            if value & (1 << day.rawValue) != 0 {
                schedule.append(day)
            }
        }
        return schedule
    }
}
