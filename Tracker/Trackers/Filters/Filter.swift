//
//  Filter.swift
//  Tracker
//
//  Created by Тася Галкина on 14.06.2024.
//

import Foundation

enum Filter: String, CaseIterable {
    case all = "Все трекеры"
    case today = "Трекеры на сегодня"
    case completed = "Завершенные"
    case uncompleted = "Незавершенные"
}
