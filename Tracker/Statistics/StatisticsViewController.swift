//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 08.05.2024.
//

import Foundation
import UIKit

class StatisticsViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        configureTrackersLabel()
//        title = "Second вкладка"
    }
    
    private var trackersLabel = UILabel()
    
    private func configureTrackersLabel() {
        view.addSubview(trackersLabel)
        trackersLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersLabel.text = "\u{1F600}"
        trackersLabel.font = UIFont.boldSystemFont(ofSize: 34)
        trackersLabel.textColor = .black
        NSLayoutConstraint.activate([
            trackersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor,constant: 44),
            trackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
}
