//
//  CategoryViewModel.swift
//  Tracker
//
//  Created by Тася Галкина on 07.06.2024.
//

import Foundation

typealias Binding<T> = (T) -> Void

final class CategoryViewModel: TrackerCategoryStoreDelegate {
    
    var onTrackerCategoriesChanged: Binding<Any?>?
    var onCategorySelected: Binding<TrackerCategory>?
    
    var selectedCategoryIndex: Int = -1
    var trackerCategories: [TrackerCategory] = [] {
        didSet {
            onTrackerCategoriesChanged?(nil)
        }
    }
    
    private var trackerCategoryStore = TrackerCategoryStore.shared
    
    init() {
        trackerCategoryStore.setDelegate(self)
    }
    
    func fetchCategories() throws {
        do {
            trackerCategories = try trackerCategoryStore.getCategories()
        } catch {
            print("Fetch failed")
        }
    }
    
    func countCategories() -> Int {
        return trackerCategories.count
    }
    
    func getCategoryTitle(at indexPath: IndexPath) -> String {
        trackerCategories[indexPath.row].title
    }
    
    func selectCategory(at indexPath: IndexPath) {
        selectedCategoryIndex = indexPath.row
        
        let selectedCategory = trackerCategories[indexPath.row]
        
        onCategorySelected?(selectedCategory)
    }
    
    func didUpdate(_ update: TrackerCategoryStoreUpdate) {
        try? fetchCategories()
    }
}
