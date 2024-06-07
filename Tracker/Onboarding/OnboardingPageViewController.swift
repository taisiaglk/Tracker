//
//  OnboardingPageViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 07.06.2024.
//

import Foundation
import UIKit

class OnboardingPageViewController: UIViewController {
    
    private let pageImage: String
    private let pageText: String
    
    let backgroundImageView = UIImageView()
    let textLabel = UILabel()
    
    init(pageImage: String, pageText: String) {
        self.pageImage = pageImage
        self.pageText = pageText
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBackgroundImageView()
        configureTextLabel()
    }
    
    private func configureBackgroundImageView() {
        backgroundImageView.image = UIImage(named: pageImage)
        view.addSubview(backgroundImageView)
        backgroundImageView.contentMode = .scaleAspectFill
        backgroundImageView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            backgroundImageView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            backgroundImageView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            backgroundImageView.topAnchor.constraint(equalTo: view.topAnchor),
            backgroundImageView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureTextLabel() {
        view.addSubview(textLabel)
        textLabel.numberOfLines = 0
        textLabel.textColor = .black_forAll
        textLabel.font = .systemFont(ofSize: 32, weight: .bold)
        textLabel.textAlignment = .center
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = pageText
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            textLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 388)
        ])
    }
}
