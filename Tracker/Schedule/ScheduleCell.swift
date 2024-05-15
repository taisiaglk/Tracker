//
//  ScheduleCell.swift
//  Tracker
//
//  Created by Тася Галкина on 13.05.2024.
//

import UIKit

protocol ScheduleCellDelegate: AnyObject {
    func didToggleSwitch(day: WeekDay, active: Bool)
}

final class ScheduleCell: UITableViewCell {
    
    static let identifier = "ScheduleCell"
    
    private let dayLabel = UILabel()
    private let toggleSwitch = UISwitch()
    
    weak var delegate: ScheduleCellDelegate?
    private var day: WeekDay?
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(dayLabel)
        contentView.addSubview(toggleSwitch)
        
        dayLabel.translatesAutoresizingMaskIntoConstraints = false
        toggleSwitch.translatesAutoresizingMaskIntoConstraints = false
        
        toggleSwitch.addTarget(self, action: #selector(didToggleSwitch), for: .valueChanged)
        
        toggleSwitch.onTintColor = .blue_color
        selectionStyle = .none
        
        NSLayoutConstraint.activate([
            dayLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            dayLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            
            toggleSwitch.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            toggleSwitch.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(day: WeekDay, active: Bool, position: CommonCellView.Position) {
        dayLabel.text = day.day
        toggleSwitch.isOn = active
        self.day = day
    }
    
    @objc private func didToggleSwitch() {
        guard let day = day else { return }
        delegate?.didToggleSwitch(day: day, active: toggleSwitch.isOn)
    }
}

