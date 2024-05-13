//
//  Tracker.swift
//  Tracker
//
//  Created by Тася Галкина on 11.05.2024.

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
    let schedule: [WeekDay]?
    
    init(id: UUID = UUID(), name: String, color: UIColor, emoji: String, schedule: [WeekDay]?) {
        self.id = id
        self.name = name
        self.color = color
        self.emoji = emoji
        self.schedule = schedule
    }
    
    struct Track {
        var name: String = ""
        var color: UIColor? = nil
        var emoji: String? = nil
        var schedule: [WeekDay]? = nil
    }
}
