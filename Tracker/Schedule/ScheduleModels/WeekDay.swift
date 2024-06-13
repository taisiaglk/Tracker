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
            return "Понедельник"
        case .tuesday:
            return "Вторник"
        case .wednesday:
            return "Среда"
        case .thursday:
            return "Четверг"
        case .friday:
            return "Пятница"
        case .saturday:
            return "Суббота"
        case .sunday:
            return "Воскресенье"
        }
    }
    
    var shortDay: String {
        switch self {
        case .monday:
            return "Пн"
        case .tuesday:
            return "Вт"
        case .wednesday:
            return "Ср"
        case .thursday:
            return "Чт"
        case .friday:
            return "Пт"
        case .saturday:
            return "Сб"
        case .sunday:
            return "Вс"
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
