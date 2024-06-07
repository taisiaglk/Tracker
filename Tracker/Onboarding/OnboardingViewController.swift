//
//  OnboardingViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 07.06.2024.
//

import Foundation
import UIKit

final class OnboardingViewController: UIPageViewController {
    
    override init(
        transitionStyle style: UIPageViewController.TransitionStyle,
        navigationOrientation: UIPageViewController.NavigationOrientation,
        options: [UIPageViewController.OptionsKey : Any]? = nil
    ) {
        super.init(
            transitionStyle: .scroll,
            navigationOrientation: navigationOrientation,
            options: options
        )
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var onboardingCompletionHandler: (() -> Void)?
    
    private lazy var pages: [OnboardingPageViewController] = [
        OnboardingPageViewController(pageImage: "Onboarding1", pageText: "Отслеживайте только\nто, что хотите"),
        OnboardingPageViewController(pageImage: "Onboarding2", pageText: "Даже если это\nне литры воды и йога")
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        configureDoneButton()
        configureConstraints()
        
        guard let firstViewController = pages.first else {
            return
        }
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
        dataSource = self
        delegate = self
    }
    
    let pageControl = UIPageControl()
    let doneButton = UIButton()
    
    private func configurePageControl() {
        view.addSubview(pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black_forAll
        pageControl.pageIndicatorTintColor = .black_forAll.withAlphaComponent(0.3)
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
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
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: doneButton.topAnchor, constant: -24),
            doneButton.heightAnchor.constraint(equalToConstant: 60),
            doneButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            doneButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            doneButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -50)
        ])
    }
    
    @objc private func doneButtonTapped() {
        onboardingCompletionHandler?()
    }
    
    @objc private func pageControlChanged() {
        let currentPage = pageControl.currentPage
        if currentPage < pages.count {
            setViewControllers([pages[currentPage]], direction: .forward, animated: true, completion: nil)
        }
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        
        guard let viewController = viewController as? OnboardingPageViewController else { return nil }
        
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let previousIndex = viewControllerIndex - 1
        guard previousIndex >= 0 else {
            return pages.last
        }
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageViewController else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = viewControllerIndex + 1
        guard nextIndex < pages.count else {
            return pages.first
        }
        return pages[nextIndex]
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {
    
    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        if let currentViewController = pageViewController.viewControllers?.first as? OnboardingPageViewController,
           let currentIndex = pages.firstIndex(of: currentViewController) {
            pageControl.currentPage = currentIndex
        }
    }
}
