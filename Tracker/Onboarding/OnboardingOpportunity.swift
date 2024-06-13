//
//  OnboardingOpportunity.swift
//  Tracker
//
//  Created by Тася Галкина on 07.06.2024.
//

import Foundation

protocol OnboardingOpportunityProtocol {
    
    func isNeedShowOnboarding() -> Bool
    
    func onboardingShowed()
}

class OnboardingOpportunity: OnboardingOpportunityProtocol {
    
    static let shared = OnboardingOpportunity()
    
    private static let isShowOnboarding = "isShowOnboarding"
    
    private let defaults = UserDefaults.standard
    
    private init() {
    
    }
    
    func isNeedShowOnboarding() -> Bool {
        defaults.object(forKey: OnboardingOpportunity.isShowOnboarding) as? Bool ?? true
    }
    
    func onboardingShowed() {
        defaults.set(false, forKey: OnboardingOpportunity.isShowOnboarding)
    }
}
