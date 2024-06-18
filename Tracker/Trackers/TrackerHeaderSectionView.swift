//
//  TrackerHeaderSectionView.swift
//  Tracker
//
//  Created by Тася Галкина on 13.05.2024.
//

import Foundation
import UIKit

class TrackerHeaderSectionView: UICollectionReusableView {
    
    let titleLabel = UILabel()
    
    static let identifier = "headerCellIdentifier"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureTitileLabel()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureTitileLabel() {
        addSubview(titleLabel)
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        titleLabel.textColor = .black_color
        titleLabel.font = UIFont.systemFont(ofSize: 19, weight: .bold)
        titleLabel.numberOfLines = 0
        titleLabel.textAlignment = .left
        
        NSLayoutConstraint.activate([
            titleLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 28),
            titleLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16),
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -12)
        ])
    }
    
    func putText(_ text: String) {
        titleLabel.text = text
    }
}
