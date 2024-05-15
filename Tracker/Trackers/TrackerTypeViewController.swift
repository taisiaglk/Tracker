//
//  TrackerTypeViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 12.05.2024.
//

import Foundation
import UIKit

protocol TrackerTypeViewControllerDelegate: AnyObject {
    func didCreateTracker(with: TrackerTypeViewController.TrackerVersion)
}

final class TrackerTypeViewController: UIViewController {
    
    let habitButton = UIButton()
    let eventButton = UIButton()
    let buttonStack = UIStackView()
    
    private func configureHabitButton() {
        buttonStack.addArrangedSubview(habitButton)
        habitButton.translatesAutoresizingMaskIntoConstraints = false
        habitButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        habitButton.setTitle("Привычка", for: .normal)
        habitButton.setTitleColor(.white_color, for: .normal)
        habitButton.backgroundColor = .black_color
        habitButton.layer.cornerRadius = 16
        habitButton.addTarget(self, action: #selector(didTapHabitButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            habitButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureEventButton() {
        buttonStack.addArrangedSubview(eventButton)
        eventButton.translatesAutoresizingMaskIntoConstraints = false
        eventButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        eventButton.setTitle("Нерегулярное событие", for: .normal)
        eventButton.setTitleColor(.white_color, for: .normal)
        eventButton.backgroundColor = .black_color
        eventButton.layer.cornerRadius = 16
        eventButton.addTarget(self, action: #selector(didTapEventButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            eventButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureButtonStack() {
        view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 16
        buttonStack.axis = .vertical
        NSLayoutConstraint.activate([
            buttonStack.centerYAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerYAnchor),
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20)
        ])
    }
    
    private func addToSCreen() {
        configureButtonStack()
        configureHabitButton()
        configureEventButton()
    }
    
    weak var delegate: TrackerTypeViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Создание трекера"
        view.backgroundColor = .white_color
        addToSCreen()
    }
    
    enum TrackerVersion {
        case habit, event
    }
    
    @objc func didTapHabitButton() {
        title = "Новая привычка"
        delegate?.didCreateTracker(with: .habit)
    }
    
    @objc func didTapEventButton() {
        title = "Новое нерегулярное событие"
        delegate?.didCreateTracker(with: .event)
    }
}


