//
//  TrackerCell.swift
//  Tracker
//
//  Created by Тася Галкина on 12.05.2024.
//

import Foundation
import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapExecButton(cell: TrackerCell, with tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
    
    let cardView = UIView()
    let emojiView = UIView()
    let emojiLabel = UILabel()
    let trackerLabel = UILabel()
    let daysLabel = UILabel()
    let execButton = UIButton()
    
    private func configureCardView() {
        contentView.addSubview(cardView)
        cardView.translatesAutoresizingMaskIntoConstraints = false
        cardView.layer.borderWidth = 1
        cardView.layer.borderColor = UIColor(red: 0xAE/255.0, green: 0xAF/255.0, blue: 0xB4/255.0, alpha: 0.3).cgColor
        cardView.layer.cornerRadius = 16
        NSLayoutConstraint.activate([
            cardView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cardView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cardView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cardView.heightAnchor.constraint(equalToConstant: 90)
        ])
    }
    
    private func configureEmojiView() {
        contentView.addSubview(emojiView)
        emojiView.translatesAutoresizingMaskIntoConstraints = false
        emojiView.layer.cornerRadius = 12
        emojiView.backgroundColor = UIColor(red: 0xFF/255.0, green: 0xFF/255.0, blue: 0xFF/255.0, alpha: 0.2)
        NSLayoutConstraint.activate([
            emojiView.topAnchor.constraint(equalTo: cardView.topAnchor, constant: 12),
            emojiView.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            emojiView.widthAnchor.constraint(equalToConstant: 24),
            emojiView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureEmojiLabel() {
        contentView.addSubview(emojiLabel)
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
    }
    
    private func configureTrackerLabel() {
        contentView.addSubview(trackerLabel)
        trackerLabel.translatesAutoresizingMaskIntoConstraints = false
        trackerLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        trackerLabel.textColor = UIColor.white
        trackerLabel.numberOfLines = 0
        NSLayoutConstraint.activate([
            trackerLabel.bottomAnchor.constraint(equalTo: cardView.bottomAnchor, constant: -12),
            trackerLabel.leadingAnchor.constraint(equalTo: cardView.leadingAnchor, constant: 12),
            trackerLabel.trailingAnchor.constraint(equalTo: cardView.trailingAnchor, constant: 12)
        ])
    }
    
    private func configureDaysLabel() {
        contentView.addSubview(daysLabel)
        daysLabel.translatesAutoresizingMaskIntoConstraints = false
        daysLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        daysLabel.textColor = .black_color
        NSLayoutConstraint.activate([
            daysLabel.topAnchor.constraint(equalTo: cardView.bottomAnchor, constant: 16),
            daysLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12)
        ])
    }
    
    private func configureEexecButton() {
        contentView.addSubview(execButton)
        execButton.translatesAutoresizingMaskIntoConstraints = false
        execButton.setImage(UIImage(systemName: "plus"), for: .normal)
        execButton.tintColor = .white_color
        execButton.layer.cornerRadius = 17
        execButton.addTarget(self, action: #selector(didTapExecButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            execButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            execButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            execButton.widthAnchor.constraint(equalToConstant: 34),
            execButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    weak var delegate: TrackerCellDelegate?
    private var tracker: Tracker?
    private var daysCount = 0 {
        willSet {
            daysLabel.text = daysString(count: newValue)
        }
    }
    
    static let identifier = "TrackerCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addToScreen()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        tracker = nil
        daysCount = 0
        execButton.setImage(UIImage(systemName: "plus"), for: .normal)
        execButton.layer.opacity = 1
    }
    
    func configure(with tracker: Tracker, days: Int, active: Bool) {
        self.tracker = tracker
        self.daysCount = days
        cardView.backgroundColor = tracker.color
        emojiLabel.text = tracker.emoji
        trackerLabel.text = tracker.name
        execButton.backgroundColor = tracker.color
        changeImageButton(active: active)
    }
    
    func changeImageButton(active: Bool) {
        execButton.setImage(active ? UIImage(systemName: "checkmark") : UIImage(systemName: "plus"), for: .normal)
        execButton.layer.opacity = active ? 0.3 : 1
    }
    
    func addOrSubtrack(value: Bool) {
        if value == true {
            daysCount += 1
        } else {
            daysCount -= 1
        }
    }
    
    func daysString(count: Int) -> String {
        var result: String
        switch (count % 10) {
        case 1: result = "\(count) день"
        case 2: result = "\(count) дня"
        case 3: result = "\(count) дня"
        case 4: result = "\(count) дня"
        default: result = "\(count) дней"
        }
        return result
    }
}

private extension TrackerCell {
    
    @objc func didTapExecButton() {
        guard let tracker else { return }
        delegate?.didTapExecButton(cell: self, with: tracker)
    }
    
    func addToScreen() {
        configureCardView()
        configureDaysLabel()
        configureEmojiView()
        configureEmojiLabel()
        configureEexecButton()
    }
}
