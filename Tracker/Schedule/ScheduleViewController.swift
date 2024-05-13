//
//  ScheduleViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 13.05.2024.
//

import Foundation
import UIKit

protocol ScheduleViewControllerDelegate: AnyObject {
    func didRdy(activeDays: [WeekDay])
}

final class ScheduleViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Расписание"
        view.backgroundColor = .white
        
        weekdaysTable.dataSource = self
        weekdaysTable.delegate = self
        
        configureWeekdaysTable()
        configureReadyButton()
    }
    
    let weekdaysTable = UITableView()
    let readyButton = UIButton()
    
    weak var delegate: ScheduleViewControllerDelegate?
    private var markedWeekdays: Set<WeekDay> = []
    
    init(markedWeekdays: [WeekDay]) {
        super.init(nibName: nil, bundle: nil)
        self.markedWeekdays = Set(markedWeekdays)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureWeekdaysTable() {
        view.addSubview(weekdaysTable)
        weekdaysTable.translatesAutoresizingMaskIntoConstraints = false
        weekdaysTable.separatorStyle = .none
        weekdaysTable.isScrollEnabled = false
        weekdaysTable.register(ScheduleCell.self, forCellReuseIdentifier: ScheduleCell.identifier)
        
        NSLayoutConstraint.activate([
            weekdaysTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            weekdaysTable.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            weekdaysTable.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureReadyButton() {
        view.addSubview(readyButton)
        readyButton.translatesAutoresizingMaskIntoConstraints = false
        readyButton.backgroundColor = .black
        readyButton.setTitleColor(.white, for: .normal)
        readyButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        readyButton.setTitle("Готово", for: .normal)
        readyButton.layer.cornerRadius = 16
        readyButton.addTarget(self, action: #selector(didTapRdyButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            readyButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            readyButton.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            readyButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            readyButton.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    @objc private func didTapRdyButton() {
        let days = Array(markedWeekdays).sorted { (day1, day2) -> Bool in
            guard let weekday1 = WeekDay.allCases.firstIndex(of: day1),
                  let weekday2 = WeekDay.allCases.firstIndex(of: day2) else { return false }
            return weekday1 < weekday2
        }
        delegate?.didRdy(activeDays: days)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        NSLayoutConstraint.activate([
            weekdaysTable.bottomAnchor.constraint(equalTo: readyButton.topAnchor, constant: -16)
        ])
    }
}

extension ScheduleViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return WeekDay.allCases.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: ScheduleCell.identifier) as? ScheduleCell else { return UITableViewCell() }
        
        var position: CommonCellView.Position
        let weekday = WeekDay.allCases[indexPath.row]
        
        switch indexPath.row {
        case 0:
            position = .top
        case 1...5:
            position = .middle
        case 6:
            position = .bottom
        default:
            position = .common
        }
        
        cell.configure(day: weekday, active: markedWeekdays.contains(weekday), position: position)
        cell.delegate = self
        return cell
    }
}

extension ScheduleViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension ScheduleViewController: ScheduleCellDelegate {
    func didToggleSwitch(day: WeekDay, active: Bool) {
        if active {
            markedWeekdays.insert(day)
        } else {
            markedWeekdays.remove(day)
        }
    }
}

