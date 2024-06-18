//
//  ViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 08.05.2024.
//

import UIKit

final class TabBarController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let separator = UIView(frame: CGRect(x: 0, y: 0, width: tabBar.frame.width, height: 1))
        separator.backgroundColor = .gray_separator
        tabBar.addSubview(separator)
        
        let trackersViewController = TrackersViewController()
        trackersViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("tabBarTrackers.title", comment: ""), image: UIImage(named: "Trackers"), tag: 0)
        
        let statisticsViewController = StatisticsViewController()
        statisticsViewController.tabBarItem = UITabBarItem(title: NSLocalizedString("tabBarStatistics.title", comment: ""), image: UIImage(named: "Stats"), tag: 1)
        
        viewControllers = [trackersViewController, statisticsViewController]
    }
}

