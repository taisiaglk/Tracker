//
//  EmojiAndColorCell.swift
//  Tracker
//
//  Created by Тася Галкина on 18.05.2024.
//

import Foundation
import UIKit

final class EmojiAndColorCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EmojiAndColorCell"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        configureCell()
    }
    
    private func configureCell() {
        contentView.addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textAlignment = .center
        titleLabel.layer.cornerRadius = 8
        titleLabel.layer.masksToBounds = true
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 6),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 6),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -6),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -6)
        ])
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(withEmoji emoji: String?, backgroundColor: UIColor?) {
        titleLabel.text = emoji
        self.backgroundColor = backgroundColor
    }
}
