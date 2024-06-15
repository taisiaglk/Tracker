//
//  EmptySearchPlaceholderView.swift
//  Tracker
//
//  Created by Тася Галкина on 14.06.2024.
//

import Foundation
import UIKit

final class EmptySearchPlaceholderView: UIView {
    
    let emptySearchImage = UIImageView()
    let textLabel = UILabel()
    
    private func configureEmptySearchImage() {
        addSubview(emptySearchImage)
//        let emptySearchImage = UIImageView()
        emptySearchImage.image = UIImage(named: "emptySearch")
        emptySearchImage.contentMode = .scaleToFill
        emptySearchImage.translatesAutoresizingMaskIntoConstraints = false
        emptySearchImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptySearchImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: emptySearchImage.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
    
    private func configureTextLabel() {
        addSubview(textLabel)
//       let textLabel = UILabel()
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = NSLocalizedString("emptySearch.text", comment: "")
        textLabel.numberOfLines = 0
        textLabel.textColor = .black_color
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textAlignment = NSTextAlignment.center
        
        NSLayoutConstraint.activate([
            emptySearchImage.centerYAnchor.constraint(equalTo: centerYAnchor),
            emptySearchImage.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }

    func configureEmptySearchPlaceholder() {
        
        configureEmptySearchImage()
        configureTextLabel()
        translatesAutoresizingMaskIntoConstraints = false
        

//        NSLayoutConstraint.activate([
//            textLabel.topAnchor.constraint(equalTo: emptySearchImage.bottomAnchor, constant: 8),
//            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
//
//            emptySearchImage.centerYAnchor.constraint(equalTo: centerYAnchor),
//            emptySearchImage.centerXAnchor.constraint(equalTo: centerXAnchor)
//        ])
    }
}
