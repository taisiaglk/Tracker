//
//  TrackerCategoryStore.swift
//  Tracker
//
//  Created by Тася Галкина on 29.05.2024.
//

import Foundation
import UIKit
import CoreData


struct TrackerCategoryStoreUpdate {
    let insertedIndexPaths: [IndexPath]
    let deletedIndexPaths: [IndexPath]
}

private enum TrackerCategoryStoreError: Error {
    case decodingErrorInvalidTitle
    case decodingErrorInvalidTrackers
    case failedToInitializeTracker
    case failedToFetchCategory
}

protocol TrackerCategoryStoreDelegate: AnyObject {
    func didUpdate(_ update: TrackerCategoryStoreUpdate)
}

protocol TrackerCategoryStoreProtocol {
    func setDelegate(_ delegate: TrackerCategoryStoreDelegate)
    func getCategories() throws -> [TrackerCategory]
    func fetchCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData
    func addCategory(_ category: TrackerCategory) throws
}

final class TrackerCategoryStore: NSObject {
    
    static let shared = TrackerCategoryStore()
    
    weak var delegate: TrackerCategoryStoreDelegate?
    
    private lazy var trackerStore: TrackerStore = {
        TrackerStore.shared
    }()
    
    private var insertedIndexPaths: [IndexPath] = []
    private var deletedIndexPaths: [IndexPath] = []
    
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCategoryCoreData> = {
        let fetchedRequest = TrackerCategoryCoreData.fetchRequest()
        fetchedRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCategoryCoreData.title, ascending: true)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchedRequest,
            managedObjectContext: context,
            sectionNameKeyPath: nil,
            cacheName: nil
        )
        controller.delegate = self
        
        try? controller.performFetch()
        return controller
    }()
    
    private convenience override init() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { fatalError("UIApplication is not AppDelegate") }
        let context = appDelegate.persistentContainer.viewContext
        
        self.init(context: context)
    }
    
    private init(context: NSManagedObjectContext) {
        self.context = context
        super.init()
    }
    
    private func saveContext() throws {
        guard context.hasChanges else { return }
        do {
            try context.save()
        } catch {
            context.rollback()
            throw error
        }
    }
    
    private func convertToTrackerCategory(from trackerCategoryCoreData: TrackerCategoryCoreData) throws -> TrackerCategory {
        guard let title = trackerCategoryCoreData.title else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTitle
        }
        guard let trackersSet = trackerCategoryCoreData.trackers as? Set<TrackerCoreData> else {
            throw TrackerCategoryStoreError.decodingErrorInvalidTrackers
        }
        let trackerList = try trackersSet.compactMap { trackerCoreData -> Tracker in
            guard let tracker = try? trackerStore.fetchTracker(trackerCoreData) else {
                throw TrackerCategoryStoreError.failedToInitializeTracker
            }
            return tracker
        }
        return TrackerCategory(title: title, trackers: trackerList)
    }
    
    private func fetchCategories() throws -> [TrackerCategory] {
        guard let objects = fetchedResultsController.fetchedObjects else {
            throw TrackerCategoryStoreError.failedToFetchCategory
        }
        let categories = try objects.map { try convertToTrackerCategory(from: $0) }
        return categories
    }
    
    private func fetchTrackerCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerCategoryCoreData.title), category.title
        )
        guard let categoryCoreData = try context.fetch(request).first else {
            throw TrackerCategoryStoreError.failedToFetchCategory
        }
        return categoryCoreData
    }
    
    private func ensureUniqueCategoryTitle(with title: String) throws {
        let request = TrackerCategoryCoreData.fetchRequest()
        request.predicate = NSPredicate(
            format: "%K = %@",
            #keyPath(TrackerCategoryCoreData.title), title
        )
        let count = try context.count(for: request)
        guard count == 0 else {
            return
        }
    }
    
    private func addNewCategory(_ category: TrackerCategory) throws {
        try ensureUniqueCategoryTitle(with: category.title)
        let categoryCoreData = TrackerCategoryCoreData(context: context)
        categoryCoreData.title = category.title
        categoryCoreData.trackers = NSSet()
        try saveContext()
    }
}

extension TrackerCategoryStore: NSFetchedResultsControllerDelegate {
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.didUpdate(
            TrackerCategoryStoreUpdate(
                insertedIndexPaths: insertedIndexPaths,
                deletedIndexPaths: deletedIndexPaths
            )
        )
        insertedIndexPaths.removeAll()
        deletedIndexPaths.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        case .delete:
            if let indexPath = indexPath {
                deletedIndexPaths.append(indexPath)
            }
        default:
            break
        }
    }
}

extension TrackerCategoryStore: TrackerCategoryStoreProtocol {
    
    func setDelegate(_ delegate: TrackerCategoryStoreDelegate) {
        self.delegate = delegate
    }
    
    func getCategories() throws -> [TrackerCategory] {
        try fetchCategories()
    }
    
    func fetchCategoryCoreData(for category: TrackerCategory) throws -> TrackerCategoryCoreData {
        try fetchTrackerCategoryCoreData(for: category)
    }
    
    func addCategory(_ category: TrackerCategory) throws {
        try addNewCategory(category)
    }
}

