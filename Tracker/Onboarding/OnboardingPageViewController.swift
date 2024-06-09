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
    let doneButton = UIButton()
    
    var onboardingCompletionHandler: (() -> Void)?
    
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
        configureDoneButton()
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
    
    private func configureDoneButton() {
        view.addSubview(doneButton)
        doneButton.translatesAutoresizingMaskIntoConstraints = false
        doneButton.backgroundColor = .black_forAll
        doneButton.layer.cornerRadius = 16
        doneButton.layer.masksToBounds = true
        doneButton.setTitle("Вот это технологии!", for: .normal)
        doneButton.setTitleColor(.white, for: .normal)
        doneButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        doneButton.addTarget(self, action: #selector(doneButtonTapped), for: .touchUpInside)
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    private let onboardingOpportunity: OnboardingOpportunityProtocol = OnboardingOpportunity.shared
    
    @objc private func doneButtonTapped() {
        onboardingCompletionHandler?()
        let tabBarController = TabBarController()
        tabBarController.modalPresentationStyle = .currentContext
        present(tabBarController, animated: true)
        onboardingOpportunity.onboardingShowed()
    }
}
