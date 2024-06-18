//
//  TrackerTests.swift
//  TrackerTests
//
//  Created by Тася Галкина on 14.06.2024.
//

import XCTest
import SnapshotTesting

@testable import Tracker

class TrackerTests: XCTestCase {

    func testingTrackersViewControllerLightStyle() {
            let trackersViewController = TrackersViewController()
            
            assertSnapshot(matching: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .light)))
        }
        
        func testingTrackersViewControllerDarkStyle() {
            let trackersViewController = TrackersViewController()
            
            assertSnapshot(matching: trackersViewController, as: .image(traits: .init(userInterfaceStyle: .dark)))
        }
    
}
