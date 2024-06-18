//
//  StatisticsCell.swift
//  Tracker
//
//  Created by Тася Галкина on 15.06.2024.
//

import Foundation
import UIKit

final class StatisticsCell: UICollectionViewCell {
    
    static let identifier = "StatisticsCell"
    
    let countLabel = UILabel()
    let titleLabel = UILabel()
    
    private func configureCountLabel() {
        contentView.addSubview(countLabel)
        
        countLabel.font = UIFont.systemFont(ofSize: 34, weight: .bold)
        countLabel.textColor = .black_color
        countLabel.textAlignment = .left
        countLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            countLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            countLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            countLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12)
            ])
    }
    
    private func configureTitleLabel() {
        contentView.addSubview(titleLabel)
        
        titleLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        titleLabel.textColor = .black_color
        titleLabel.textAlignment = .left
        
        titleLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleLabel.topAnchor.constraint(equalTo: countLabel.bottomAnchor, constant: 7),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 12),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -12),
            titleLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12)
            ])
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupCell()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configureCell(statistics: Statistics) {
        countLabel.text = statistics.count
        titleLabel.text = statistics.title
    }
    
    private func setupCell() {
        configureCountLabel()
        configureTitleLabel()
        configureGradient()
        contentView.layer.cornerRadius = 16
        contentView.layer.masksToBounds = true
    }
    
    private func configureGradient() {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = bounds
        gradientLayer.colors = [
            UIColor.red.cgColor,
            UIColor.green.cgColor,
            UIColor.blue.cgColor
        ]
        gradientLayer.startPoint = CGPoint(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1.0, y: 0.5)
        
        let shapeLayer = CAShapeLayer()
        shapeLayer.lineWidth = 1
        shapeLayer.path = UIBezierPath(roundedRect: bounds, cornerRadius: 16).cgPath
        shapeLayer.fillColor = nil
        shapeLayer.strokeColor = UIColor.black.cgColor
        gradientLayer.mask = shapeLayer
        contentView.layer.addSublayer(gradientLayer)
    }
}

