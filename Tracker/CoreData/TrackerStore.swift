//
//  TrackerStore.swift
//  Tracker
//
//  Created by Тася Галкина on 29.05.2024.
//

import UIKit
import CoreData

struct TrackerStoreUpdate {
    let insertedSections: IndexSet
    let insertedIndexPaths: [IndexPath]
}

private enum TrackerStoreError: Error {
    case decodingErrorInvalidID
}

protocol TrackerStoreDelegate: AnyObject {
    func trackerStoreDidUpdate(_ update: TrackerStoreUpdate)
}

protocol TrackerStoreProtocol {
    func pinTrackerCoreData(_ tracker: Tracker) throws
    func setDelegate(_ delegate: TrackerStoreDelegate)
    func fetchTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker
    func addTracker(_ tracker: Tracker, toCategory category: TrackerCategory) throws
    func deleteTrackers(tracker: Tracker)
    func updateTracker(_ tracker: Tracker, to category: TrackerCategory) throws
}

final class TrackerStore: NSObject {
    
    static let shared = TrackerStore()
    
    weak var delegate: TrackerStoreDelegate?
    private var insertedSections: IndexSet = []
    private var insertedIndexPaths: [IndexPath] = []
    private var trackers: [Tracker] {
        guard
            let objects = self.fetchedResultsController.fetchedObjects,
            let trackers = try? objects.map({ try self.convertToTracker(from: $0) })
        else { return [] }
        return trackers
    }
    
    private lazy var trackerCategoryStore: TrackerCategoryStoreProtocol = {
        TrackerCategoryStore.shared
    }()
    
    private let context: NSManagedObjectContext
    private lazy var fetchedResultsController: NSFetchedResultsController<TrackerCoreData> = {
        let fetchRequest = TrackerCoreData.fetchRequest()
        fetchRequest.sortDescriptors = [
            NSSortDescriptor(keyPath: \TrackerCoreData.name, ascending: true),
            NSSortDescriptor(keyPath: \TrackerCoreData.category?.title, ascending: false)
        ]
        
        let controller = NSFetchedResultsController(
            fetchRequest: fetchRequest,
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
    }
    
    private func convertToTracker(from trackerCoreData: TrackerCoreData) throws -> Tracker {
        guard let id = trackerCoreData.idTracker,
              let title = trackerCoreData.name,
              let colorString = trackerCoreData.color,
              let emoji = trackerCoreData.emoji
        else {
            throw TrackerStoreError.decodingErrorInvalidID
        }
        
        let isPinned = trackerCoreData.isPinned
        let color = UIColor.color(from: colorString)
        let schedule = WeekDay.calculateScheduleArray(from: trackerCoreData.schedule)
        
        return Tracker(
            id: id,
            name: title,
            color: color,
            emoji: emoji,
            schedule: schedule,
            isPinned: isPinned
        )
    }
    
    func addTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
        let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
        
        // Check if tracker already exists
        let fetchRequest: NSFetchRequest<TrackerCoreData> = TrackerCoreData.fetchRequest()
        fetchRequest.predicate = NSPredicate(format: "idTracker == %@", tracker.id as CVarArg)
        
        let existingTrackers = try context.fetch(fetchRequest)
        if existingTrackers.isEmpty {
            let trackerCoreData = TrackerCoreData(context: context)
            trackerCoreData.idTracker = tracker.id
            trackerCoreData.name = tracker.name
            trackerCoreData.color = tracker.color.hexString()
            trackerCoreData.emoji = tracker.emoji
            trackerCoreData.schedule = WeekDay.calculateScheduleValue(for: tracker.schedule ?? [])
            trackerCoreData.category = trackerCategoryCoreData
            trackerCoreData.isPinned = tracker.isPinned
            
            try saveContext()
        } else {
            print("Tracker with this ID already exists")
        }
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
    
    func updateTracker(with tracker: Tracker, to category: TrackerCategory) throws {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "idTracker == %@", tracker.id as CVarArg)
        do {
//            let existingTrackers = try context.fetch(fetchRequest)
            print(tracker)
            print("111")
            let existingTrackers = try context.fetch(fetchRequest)
//            print(existingTrackers.id)
            if let existingTracker = existingTrackers.first {
                existingTracker.idTracker = tracker.id
                existingTracker.name = tracker.name
                existingTracker.color = tracker.color.hexString()
                existingTracker.emoji = tracker.emoji
                existingTracker.schedule = WeekDay.calculateScheduleValue(for: tracker.schedule ?? [])
                let trackerCategoryCoreData = try trackerCategoryStore.fetchCategoryCoreData(for: category)
                existingTracker.category = trackerCategoryCoreData
                existingTracker.isPinned = tracker.isPinned
                print(existingTracker)
                try saveContext()
            }
        }
    }
}

extension TrackerStore: NSFetchedResultsControllerDelegate {
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        delegate?.trackerStoreDidUpdate(
            TrackerStoreUpdate(
                insertedSections: insertedSections,
                insertedIndexPaths: insertedIndexPaths
            )
        )
        insertedSections.removeAll()
        insertedIndexPaths.removeAll()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange sectionInfo: NSFetchedResultsSectionInfo, atSectionIndex sectionIndex: Int, for type: NSFetchedResultsChangeType) {
        switch type {
        case .insert:
            insertedSections.insert(sectionIndex)
        default:
            break
        }
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            if let indexPath = newIndexPath {
                insertedIndexPaths.append(indexPath)
            }
        default:
            break
        }
    }
}

extension TrackerStore: TrackerStoreProtocol {
    
    func setDelegate(_ delegate: TrackerStoreDelegate) {
        self.delegate = delegate
    }
    
    func fetchTracker(_ trackerCoreData: TrackerCoreData) throws -> Tracker {
        try convertToTracker(from: trackerCoreData)
    }
    
    func addTracker(_ tracker: Tracker, toCategory category: TrackerCategory) throws {
        try addTracker(tracker, to: category)
    }
    
    func updateTracker(_ tracker: Tracker, to category: TrackerCategory) throws {
        try updateTracker(with: tracker, to: category)
    }
    
    func pinTrackerCoreData(_ tracker: Tracker) throws {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "idTracker == %@", tracker.id as CVarArg)
        
        do {
            guard let trackerCoreData = try? context.fetch(fetchRequest) else { return }
            if let trackerToPin = trackerCoreData.first {
                if trackerToPin.isPinned == false {
                    trackerToPin.isPinned = true
                } else if trackerToPin.isPinned == true {
                    trackerToPin.isPinned = false
                }
                try context.save()
            }
        } catch {
            print("Pin tracker Failed")
        }
    }
    
    func deleteTrackers(tracker: Tracker) {
        let fetchRequest = NSFetchRequest<TrackerCoreData>(entityName: "TrackerCoreData")
        fetchRequest.predicate = NSPredicate(format: "idTracker == %@", tracker.id as CVarArg)
        do {
            let tracker = try context.fetch(fetchRequest)
            
            if let trackerToDelete = tracker.first {
                context.delete(trackerToDelete)
                try context.save()
            } else {
                print("Delete tracker error")
            }
        } catch {
            print("Delete tracker error")
        }
    }
}
