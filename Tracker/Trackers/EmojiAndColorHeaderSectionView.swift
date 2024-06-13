//
//  EmojiAndColorHeaderSectionView.swift
//  Tracker
//
//  Created by Тася Галкина on 18.05.2024.
//

import Foundation
import UIKit

final class EmojiAndColorHeaderSectionView: UICollectionReusableView {
    
    static let reuseIdentifier = "EmojiAndColorHeaderView"
    
    let titleLabel = UILabel()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(titleLabel)
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.textColor = .black_color
        titleLabel.textAlignment = .left
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
