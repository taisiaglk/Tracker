//
//  CategoryCell.swift
//  Tracker
//
//  Created by Тася Галкина on 14.05.2024.
//

import Foundation
import UIKit

final class CategoryCell: UITableViewCell {
    
    static let identifier = "CategoryCell"
    
    private let categoryName = UILabel()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setup() {
        contentView.addSubview(categoryName)
        
        categoryName.font = UIFont.systemFont(ofSize: 17)
        categoryName.numberOfLines = 0
        categoryName.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            categoryName.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            categoryName.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            categoryName.centerYAnchor.constraint(equalTo: contentView.centerYAnchor)
        ])
    }
    
    func configure(name: String) {
        categoryName.text = name
    }
}
