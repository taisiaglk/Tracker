//
//  TrackerCategory.swift
//  Tracker
//
//  Created by Тася Галкина on 11.05.2024.

import Foundation

struct TrackerCategory {
    let title: String
    let trackers: [Tracker]
    
    struct TrackCategory {
        var title: String? = nil
        var trackers: [Tracker]? = nil
    }
}


