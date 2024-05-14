//
//  CreatingCell.swift
//  Tracker
//
//  Created by Тася Галкина on 13.05.2024.
//

import Foundation
import UIKit

final class CreatingCell: UITableViewCell {
    
    private lazy var cellView = CommonCellView()
    
    let nameLabel = UILabel()
    let descriptionLabel = UILabel()
    let button = UIButton()
    let labelStack = UIStackView()
    
    static let identifier = "TableCell"
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        
        configureCell()
        configureLabelStack()
        configureNameLabel()
        configureDescriptionLabel()
        configureButton()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCell() {
        contentView.addSubview(cellView)
        
        NSLayoutConstraint.activate([
            cellView.topAnchor.constraint(equalTo: contentView.topAnchor),
            cellView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            cellView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor)
        ])
    }
    
    private func configureNameLabel() {
        labelStack.addArrangedSubview(nameLabel)
        nameLabel.translatesAutoresizingMaskIntoConstraints = false
        nameLabel.textColor = .black_color
        nameLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        
        NSLayoutConstraint.activate([
            
        ])
    }
    
    private func configureDescriptionLabel() {
        labelStack.addArrangedSubview(descriptionLabel)
        descriptionLabel.translatesAutoresizingMaskIntoConstraints = false
        descriptionLabel.textColor = .gray_color
        descriptionLabel.font = UIFont.systemFont(ofSize: 17, weight: .regular)
    }
    
    private func configureButton() {
        contentView.addSubview(button)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.setImage(UIImage(named: "ArrowRight"), for: .normal)
        button.isEnabled = false
        
        NSLayoutConstraint.activate([
            button.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            button.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureLabelStack() {
        contentView.addSubview(labelStack)
        labelStack.addArrangedSubview(nameLabel)
        labelStack.addArrangedSubview(descriptionLabel)
        labelStack.translatesAutoresizingMaskIntoConstraints = false
        labelStack.spacing = 2
        labelStack.axis = .vertical
        
        NSLayoutConstraint.activate([
            labelStack.centerYAnchor.constraint(equalTo: cellView.centerYAnchor),
            labelStack.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 16),
            labelStack.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -56)
        ])
    }
    
    func configure(name: String, description: String?, position: CommonCellView.Position) {
        nameLabel.text = name
        cellView.configure(position: position)
        
        if let description {
            descriptionLabel.text = description
        }
    }
}
