//
//  TrackerCell.swift
//  Tracker
//
//  Created by Тася Галкина on 12.05.2024.
//

import Foundation
import UIKit

protocol TrackerCellDelegate: AnyObject {
    func didTapDoneButton(cell: TrackerCell, with tracker: Tracker)
    func updateTrackerPinAction(tracker: Tracker)
    func editTrackerAction(tracker: Tracker)
    func deleteTrackerAction(tracker: Tracker)
}

final class TrackerCell: UICollectionViewCell {
    
    let cardView = UIView()
    let emojiView = UIView()
    let emojiLabel = UILabel()
    let trackerLabel = UILabel()
    let daysLabel = UILabel()
    let execButton = UIButton()
    let pinnedImage = UIImageView()
    
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
        cardView.addSubview(emojiView)
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
        cardView.addSubview(emojiLabel)
        emojiLabel.font = UIFont.systemFont(ofSize: 16)
        emojiLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            emojiLabel.centerXAnchor.constraint(equalTo: emojiView.centerXAnchor),
            emojiLabel.centerYAnchor.constraint(equalTo: emojiView.centerYAnchor)
        ])
    }
    
    private func configureTrackerLabel() {
        cardView.addSubview(trackerLabel)
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
        execButton.addTarget(self, action: #selector(didTapDoneButton), for: .touchUpInside)
        NSLayoutConstraint.activate([
            execButton.centerYAnchor.constraint(equalTo: daysLabel.centerYAnchor),
            execButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            execButton.widthAnchor.constraint(equalToConstant: 34),
            execButton.heightAnchor.constraint(equalToConstant: 34)
        ])
    }
    
    private func configurePinnedImage() {
        contentView.addSubview(pinnedImage)
        
        pinnedImage.image = UIImage(named: "Pin")
        pinnedImage.isHidden = true
        pinnedImage.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            pinnedImage.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -4),
            pinnedImage.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            pinnedImage.widthAnchor.constraint(equalToConstant: 24),
            pinnedImage.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    private func configureContextMenu() {
        let contextMenu = UIContextMenuInteraction(delegate: self)
        cardView.addInteraction(contextMenu)
    }
    
    func addToScreen() {
        configureCardView()
        configureDaysLabel()
        configureEmojiView()
        configureTrackerLabel()
        configureEmojiLabel()
        configureEexecButton()
        configurePinnedImage()
        
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
        execButton.setImage(UIImage(systemName: active ? "checkmark" : "plus"), for: .normal)
        execButton.backgroundColor = tracker.color
        changeImageButton(active: active)
        configureContextMenu()
        pinnedImage.isHidden = !tracker.isPinned
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
        let daysCounter = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "numberOfDays"), count)
        return daysCounter
    }
    
    @objc func didTapDoneButton() {
        guard let tracker else { return }
        delegate?.didTapDoneButton(cell: self, with: tracker)
    }
}

extension TrackerCell: UIContextMenuInteractionDelegate {
    func contextMenuInteraction(_ interaction: UIContextMenuInteraction, configurationForMenuAtLocation location: CGPoint) -> UIContextMenuConfiguration? {
        
        let unpinTracker = NSLocalizedString("unpinTracker.text", comment: "")
        let pinTracker = NSLocalizedString("pinTracker.text", comment: "")
        
        let titleTextIsPinned = (self.tracker?.isPinned ?? false) ? unpinTracker : pinTracker
        

        return UIContextMenuConfiguration(identifier: nil, previewProvider: nil, actionProvider:  { suggestedActions in

            let pinAction = UIAction(title: titleTextIsPinned) { action in
                guard let tracker = self.tracker else { return }
                
                self.delegate?.updateTrackerPinAction(tracker: tracker)
            }

            let editAction = UIAction(title: "Редактировать") { action in
                guard let tracker = self.tracker else { return }
                
                self.delegate?.editTrackerAction(tracker: tracker)
            }

            let deleteAction = UIAction(title: "Удалить", attributes: .destructive) { action in
                guard let tracker = self.tracker else { return }
                
                self.delegate?.deleteTrackerAction(tracker: tracker)
            }

            return UIMenu(children: [pinAction, editAction, deleteAction])
        })
    }
}

