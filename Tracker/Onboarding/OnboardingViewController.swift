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
    
    private lazy var pages: [OnboardingPageViewController] = [
        OnboardingPageViewController(pageImage: "Onboarding1", pageText: NSLocalizedString("onboardingBlueLabel.title", comment: "")),
        OnboardingPageViewController(pageImage: "Onboarding2", pageText: NSLocalizedString("onboardingRedLabel.title", comment: ""))
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurePageControl()
        
        guard let firstViewController = pages.first else {
            return
        }
        setViewControllers([firstViewController], direction: .forward, animated: true, completion: nil)
        
        dataSource = self
        delegate = self
    }
    
    let pageControl = UIPageControl()
    
    private func configurePageControl() {
        view.addSubview(pageControl)
        pageControl.numberOfPages = pages.count
        pageControl.currentPage = 0
        pageControl.translatesAutoresizingMaskIntoConstraints = false
        pageControl.currentPageIndicatorTintColor = .black_forAll
        pageControl.pageIndicatorTintColor = .black_forAll.withAlphaComponent(0.3)
        pageControl.addTarget(self, action: #selector(pageControlChanged), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            pageControl.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            pageControl.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -134)
        ])
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
        let previousIndex = (viewControllerIndex + pages.count - 1) % pages.count
        return pages[previousIndex]
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let viewController = viewController as? OnboardingPageViewController else { return nil }
        guard let viewControllerIndex = pages.firstIndex(of: viewController) else {
            return nil
        }
        let nextIndex = (viewControllerIndex + 1) % pages.count
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
