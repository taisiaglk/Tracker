//
//  PlaceholderView.swift
//  Tracker
//
//  Created by Тася Галкина on 14.06.2024.
//

import Foundation
import UIKit

final class PlaceholderView: UIView {
    
    let emptyTrackersImage = UIImageView()
    let questionLabel = UILabel()
    
    private func configureEmptyTrackersImage() {
//        let emptyTrackersImage = UIImageView()
        addSubview(emptyTrackersImage)
        
        emptyTrackersImage.image = UIImage(named: "star")
        emptyTrackersImage.contentMode = .scaleToFill
        emptyTrackersImage.translatesAutoresizingMaskIntoConstraints = false
        emptyTrackersImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptyTrackersImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            questionLabel.topAnchor.constraint(equalTo: emptyTrackersImage.bottomAnchor, constant: 8),
            questionLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            questionLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
        
    }
    
    private func configureQuestionLabel() {
//        let questionLabel = UILabel()
        addSubview(questionLabel)
        
        questionLabel.translatesAutoresizingMaskIntoConstraints = false
        questionLabel.text = NSLocalizedString("emptyState.text", comment: "")
        questionLabel.numberOfLines = 0
        questionLabel.textColor = .black_color
        questionLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        questionLabel.textAlignment = NSTextAlignment.center
        
        NSLayoutConstraint.activate([
            emptyTrackersImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptyTrackersImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    func configureEmptyTrackerPlaceholder() {
        configureEmptyTrackersImage()
        configureQuestionLabel()
        
        translatesAutoresizingMaskIntoConstraints = false
    }
}
