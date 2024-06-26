//
//  AppDelegate.swift
//  Tracker
//
//  Created by Тася Галкина on 08.05.2024.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow()
        let onboardingPageViewController = OnboardingPageViewController(pageImage: "Onboarding1", pageText: "Отслеживайте только\nто, что хотите")
        onboardingPageViewController.onboardingCompletionHandler = { [weak self] in
            let tabBarController = TabBarController()
            self?.window?.rootViewController = tabBarController
        }
        
        window?.rootViewController = OnboardingViewController()
        window?.makeKeyAndVisible()
        return true
    }
    
    lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Tracker")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    func saveContext () {
        let context = persistentContainer.viewContext
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                let error = error as NSError
                assertionFailure("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    
}

