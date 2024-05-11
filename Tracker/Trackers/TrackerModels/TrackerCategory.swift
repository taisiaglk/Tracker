//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Тася Галкина on 11.05.2024.

//сущность для хранения трекеров по категориям. Она имеет заголовок и содержит массив трекеров, относящихся к этой категории.
//

import Foundation

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
}
