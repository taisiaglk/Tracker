//
//  Tracker.swift
//  Tracker
//
//  Created by Тася Галкина on 11.05.2024.


//Создан Tracker — сущность для хранения информации про трекер (для «Привычки» или «Нерегулярного события»). У него есть уникальный идентификатор (id), название, цвет, эмоджи и распиcание. Структуру данных для хранения расписания выберите на своё усмотрение.
//

import Foundation
import UIKit

struct Tracker {
    let id: UUID
    let name: String
    let color: UIColor
    let emoji: String
//    let schedule: []
}
