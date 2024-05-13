//
//  CommonCellView.swift
//  Tracker
//
//  Created by Тася Галкина on 13.05.2024.
//

import Foundation
import UIKit

final class CommonCellView: UIView {
    
    let cellViewBoard = UIView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func configureCellViewBoard() {
        addSubview(cellViewBoard)
        
        cellViewBoard.translatesAutoresizingMaskIntoConstraints = false
        cellViewBoard.backgroundColor = .gray_color
        cellViewBoard.isHidden = true
        
        NSLayoutConstraint.activate([
            cellViewBoard.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cellViewBoard.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cellViewBoard.bottomAnchor.constraint(equalTo: bottomAnchor),
            cellViewBoard.heightAnchor.constraint(equalToConstant: 0.5)
        ])
    }
    
    private func setup() {
        translatesAutoresizingMaskIntoConstraints = false
        layer.cornerRadius = 16
        layer.masksToBounds = true
        backgroundColor = .background_color
        
        configureCellViewBoard()
    }
    
    enum Position {
        case top, middle, bottom, common
    }
    
    func configure(position: Position) {
        layer.cornerRadius = 16
        
        switch position {
        case .top:
            layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
            cellViewBoard.isHidden = false
        case .middle:
            layer.cornerRadius = 0
            cellViewBoard.isHidden = false
        case .bottom:
            layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        case .common:
            break
        }
    }
}
