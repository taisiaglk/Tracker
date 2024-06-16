//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 08.05.2024.
//

import Foundation
import UIKit

class TrackersViewController: UIViewController, TrackerTypeViewControllerDelegate, UICollectionViewDelegate, UISearchBarDelegate, CreatingTrackerViewControllerDelegate{
    func updateTracker(tracker: Tracker, to category: TrackerCategory) {
        print("Updated")
        dismiss(animated: true)
        try? trackerStore.updateTracker(tracker, to: category)
        try? fetchCategories()
        reloadFilteredCategories(text: searchField.text, date: currentDate)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white_color
        reloadData()
        addToScreen()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchField.delegate = self
    }
    
    var categories: [TrackerCategory] = [TrackerCategory(title: "База", trackers: [])]
    var completedTrackers: [TrackerRecord] = []
    var selectedFilter: Filter = .all
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore.shared
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore.shared
    private let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore.shared
    private var filteredCategories: [TrackerCategory] = []
    
    private var addButton = UIButton()
    private var starImage = UIImageView()
    private var label = UILabel()
    private var trackersLabel = UILabel()
    let searchField = UISearchBar()
    let datePicker = UIDatePicker()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
    let filterButton = UIButton(type: .system)
    
    let emptySearchImage = UIImageView()
    let textLabel = UILabel()
    
    private var currentDate = Date()
    private var isEnableToAdd = true
    
    private let geomentricParams = GeometricParams(
        cellCount: 2,
        leftInset: 16,
        rightInset: 16,
        cellSpacing: 9)
    
    private var currentlyTrackers: [TrackerCategory] {
        let day = Calendar.current.component(.weekday, from: currentDate)
        var tracker = [TrackerCategory]()
        for category in categories {
            let trackersFilter = category.trackers.filter { tracker in
                guard let schedule = tracker.schedule else { return true }
                return schedule.contains(WeekDay.allCases[day > 1 ? day - 2 : day + 5])
            }
            if !trackersFilter.isEmpty {
                tracker.append(TrackerCategory(title: category.title, trackers: trackersFilter))
            }
        }
        return tracker
    }
    
    private func configureTrackersLabel() {
        view.addSubview(trackersLabel)
        trackersLabel.translatesAutoresizingMaskIntoConstraints = false
        trackersLabel.text = NSLocalizedString("trackers.title", comment: "")
        trackersLabel.font = UIFont.boldSystemFont(ofSize: 34)
        trackersLabel.textColor = .black_color
        NSLayoutConstraint.activate([
            trackersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            trackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        let image = UIImage(named: "AddTracker")?.withRenderingMode(.alwaysTemplate)
        addButton.setImage(image, for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        addButton.tintColor = .black_color
        NSLayoutConstraint.activate([
            addButton.widthAnchor.constraint(equalToConstant: 42),
            addButton.heightAnchor.constraint(equalToConstant: 42),
            addButton.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 6),
            addButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 1)
        ])
    }
    
    private func configureStarImage() {
        view.addSubview(starImage)
        starImage.translatesAutoresizingMaskIntoConstraints = false
        starImage.image = UIImage(named: "star")
        NSLayoutConstraint.activate([
            starImage.widthAnchor.constraint(equalToConstant: 80),
            starImage.heightAnchor.constraint(equalTo: starImage.widthAnchor),
            starImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            starImage.centerYAnchor.constraint(equalTo: view.centerYAnchor)
        ])
    }
    
    private func configureLabel() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = NSLocalizedString("emptyState.text", comment: "")
        label.font = UIFont.systemFont(ofSize: 12)
        label.textAlignment = .center
        NSLayoutConstraint.activate([
            label.heightAnchor.constraint(equalToConstant: 18),
            label.topAnchor.constraint(equalTo: starImage.bottomAnchor, constant: 8),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureSearchField() {
        view.addSubview(searchField)
        searchField.translatesAutoresizingMaskIntoConstraints = false
        searchField.searchBarStyle = .minimal
        searchField.placeholder = NSLocalizedString("searchTextField.placeholder", comment: "")
        
        NSLayoutConstraint.activate([
            searchField.topAnchor.constraint(equalTo: trackersLabel.bottomAnchor, constant: 7),
            searchField.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            searchField.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16)
        ])
    }
    
    private func configureDatePicker() {
        view.addSubview(datePicker)
        datePicker.translatesAutoresizingMaskIntoConstraints = false
        datePicker.tintColor = .blue_color
        datePicker.backgroundColor = .white_color
        datePicker.datePickerMode = .date
        datePicker.preferredDatePickerStyle = .compact
        datePicker.calendar = Calendar(identifier: .iso8601)
        datePicker.locale = Locale(identifier: "ru_RU")
        
        datePicker.addTarget(self, action: #selector(didChangeDate), for: .valueChanged)
        
        NSLayoutConstraint.activate([
            datePicker.centerYAnchor.constraint(equalTo: addButton.centerYAnchor),
            datePicker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            datePicker.widthAnchor.constraint(equalToConstant: 120)
        ])
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = .white_color
        collectionView.register(TrackerCell.self, forCellWithReuseIdentifier: TrackerCell.identifier)
        collectionView.register(TrackerHeaderSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "header")
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: searchField.bottomAnchor, constant: 10),
            collectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureFilterButton() {
        view.addSubview(filterButton)
        let textTitle = NSLocalizedString("filterButton.text", comment: "")
        filterButton.translatesAutoresizingMaskIntoConstraints = false
        filterButton.setTitle(textTitle, for: .normal)
        filterButton.titleLabel?.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        filterButton.setTitleColor(.white, for: .normal)
        filterButton.backgroundColor = .blue_color
        filterButton.layer.cornerRadius = 16
        filterButton.addTarget(self, action: #selector(didTapFilterButton), for: .touchUpInside)
        
        NSLayoutConstraint.activate([
            filterButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -100),
            filterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterButton.widthAnchor.constraint(equalToConstant: 114),
            filterButton.heightAnchor.constraint(equalToConstant: 50)
        ])
    }
    
//    let emptySearchImage = UIImageView()
//    let textLabel = UILabel()
    
    private func configureEmptySearchImage() {
        view.addSubview(emptySearchImage)
        emptySearchImage.image = UIImage(named: "emptySearch")
        emptySearchImage.contentMode = .scaleToFill
        emptySearchImage.translatesAutoresizingMaskIntoConstraints = false
        emptySearchImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptySearchImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        NSLayoutConstraint.activate([
            emptySearchImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptySearchImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureTextLabel() {
        view.addSubview(textLabel)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        textLabel.text = NSLocalizedString("emptySearch.text", comment: "")
        textLabel.numberOfLines = 0
        textLabel.textColor = .black_color
        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        textLabel.textAlignment = NSTextAlignment.center
        
        NSLayoutConstraint.activate([
            textLabel.topAnchor.constraint(equalTo: emptySearchImage.bottomAnchor, constant: 8),
            textLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
//    private func configureEmptySearchImage() {
//        addSubview(emptySearchImage)
//        emptySearchImage.image = UIImage(named: "emptySearch")
//        emptySearchImage.contentMode = .scaleToFill
//        emptySearchImage.translatesAutoresizingMaskIntoConstraints = false
//        emptySearchImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
//        emptySearchImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
//        
//        NSLayoutConstraint.activate([
//            textLabel.topAnchor.constraint(equalTo: emptySearchImage.bottomAnchor, constant: 8),
//            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
//            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor)
//        ])
//    }
//    
//    private func configureTextLabel() {
//        addSubview(textLabel)
//        textLabel.translatesAutoresizingMaskIntoConstraints = false
//        textLabel.text = NSLocalizedString("emptySearch.text", comment: "")
//        textLabel.numberOfLines = 0
//        textLabel.textColor = .black_color
//        textLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
//        textLabel.textAlignment = NSTextAlignment.center
//        
//        NSLayoutConstraint.activate([
//            emptySearchImage.centerYAnchor.constraint(equalTo: centerYAnchor),
//            emptySearchImage.centerXAnchor.constraint(equalTo: centerXAnchor)
//        ])
//    }
    
    private func addToScreen() {
        configureTrackersLabel()
        configureAddButton()
        configureSearchField()
        configureDatePicker()
        configureCollectionView()
        configureStarImage()
        configureLabel()
        configureFilterButton()
        configureEmptySearchImage()
        configureTextLabel()
        
        updateVisibility()
    }
    
    private func updateVisibility() {
        if currentlyTrackers.isEmpty {
            starImage.isHidden = false
            label.isHidden = false
            collectionView.isHidden = true
            textLabel.isHidden = true
            emptySearchImage.isHidden = true
        } else {
            if filteredCategories.isEmpty {
                textLabel.isHidden = false
                emptySearchImage.isHidden = false
                starImage.isHidden = true
                label.isHidden = true
                collectionView.isHidden = true
            } else {
                starImage.isHidden = true
                label.isHidden = true
                collectionView.isHidden = false
                textLabel.isHidden = true
                emptySearchImage.isHidden = true
            }
        }
    }
    
    private func reloadData() {
        do {
            categories = try trackerCategoryStore.getCategories()
        } catch {
            assertionFailure("Failed to get categories with \(error)")
        }
        
        let trackers = categories.flatMap { category in
            category.trackers
        }
        
        let records = trackers.map { tracker -> [TrackerRecord] in
            var records: [TrackerRecord] = []
            
            do {
                records = try trackerRecordStore.recordsFetch(for: tracker)
            } catch {
                assertionFailure()
            }
            
            return records
        }
        
        completedTrackers = records.flatMap { $0 }
        //        filteredCategories = categories
        filteredCategories = categories.filter { category in
            !category.trackers.isEmpty
        }
    }
    
    @objc private func addButtonTapped() {
        let createTrack = TrackerTypeViewController()
        createTrack.delegate = self
        let navigationController = UINavigationController(rootViewController: createTrack)
        present(navigationController, animated: true)
    }
    
    @objc private func didChangeDate(_ sender: UIDatePicker) {
        currentDate = sender.date
        isEnableToAdd = currentDate <= Date()
        collectionView.reloadData()
        updateVisibility()
        reloadFilteredCategories(text: searchField.text, date: currentDate)
    }
    
    @objc private func didTapFilterButton() {
        let filtersViewController = FiltersViewController()
        filtersViewController.delegate = self
        filtersViewController.selectedFilter = selectedFilter
        present(filtersViewController, animated: true)
    }
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    private func filteringTrackers(completed: Bool) {
        filteredCategories = filteredCategories.compactMap { category in
            let trackers = category.trackers.filter { tracker in
                completed ? isTrackerCompletedToday(id: tracker.id)
                : !isTrackerCompletedToday(id: tracker.id)
            }
            if trackers.isEmpty { return nil }
            return TrackerCategory(title: category.title, trackers: trackers)
        }
    }
    
    private func isTrackerCompletedToday(id: UUID) -> Bool {
        completedTrackers.contains {
            isMatchRecord(model: $0, with: id)
        }
    }
    
    private func isMatchRecord(model: TrackerRecord, with trackerID: UUID) -> Bool {
        return model.idRecord == trackerID && Calendar.current.isDate(model.date, inSameDayAs: currentDate)
    }
    
    private func isSameTrackerRecord(trackerRecord: TrackerRecord, id: UUID) -> Bool {
        let isSameDay = Calendar.current.isDate(trackerRecord.date, inSameDayAs: datePicker.date)
        return trackerRecord.idRecord == id && isSameDay
    }
    
    private func reloadFilteredCategories(text: String?, date: Date) {
        let calendar = Calendar.current
        let filteredWeekDay = calendar.component(.weekday, from: date)
        let filterText = (text ?? "").lowercased()
        currentDate = datePicker.date
        
        print("Categories count: \(categories.count)")
        
        switch selectedFilter {
        case .all:
            filteredCategories = categories.compactMap { category in
                // Фильтруем трекеры в категории
                let filteredTrackers = category.trackers.filter { tracker in
                    // Проверка условия текста
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    
                    // Проверка условия даты
                    let dateCondition: Bool
                    if let schedule = tracker.schedule {
                        dateCondition = schedule.contains { $0.rawValue == filteredWeekDay } || schedule.isEmpty
                    } else {
                        dateCondition = false
                    }
                    
                    // Возвращаем трекер, если оба условия выполнены
                    return textCondition && dateCondition
                }
                
                // Возвращаем новую категорию с отфильтрованными трекерами или nil, если трекеров нет
                print("hui \(filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers))")
                return filteredTrackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: filteredTrackers)
            }
            print("Filtered categories count: \(filteredCategories.count)") // Логирование количества отфильтрованных категорий
            
            
        case .today:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    
                    let dateCondition = tracker.schedule!.contains(where: { weekDay in
                        weekDay.rawValue == filteredWeekDay
                    }) == true || tracker.schedule!.isEmpty
                    
                    return textCondition && dateCondition
                }
                
                if trackers.isEmpty {
                    return nil
                }
                
                return TrackerCategory(title: category.title, trackers: trackers)
            }
            
        case .completed:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    let dateCondition = tracker.schedule!.contains(where: { weekDay in
                        weekDay.rawValue == filteredWeekDay
                    }) || tracker.schedule!.isEmpty
                    let incompleteCondition = completedTrackers.contains { record in
                        record.idRecord == tracker.id &&
                        Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                    }
                    
                    return textCondition && dateCondition && (incompleteCondition ?? false)
                }
                
                return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
            }
            
        case .uncompleted:
            filteredCategories = categories.compactMap { category in
                let trackers = category.trackers.filter { tracker in
                    let textCondition = filterText.isEmpty || tracker.name.lowercased().contains(filterText)
                    let dateCondition = tracker.schedule!.contains(where: { weekDay in
                        weekDay.rawValue == filteredWeekDay
                    }) || tracker.schedule!.isEmpty
                    let incompleteCondition = !completedTrackers.contains { record in
                        record.idRecord == tracker.id &&
                        Calendar.current.isDate(record.date, inSameDayAs: currentDate)
                    }
                    
                    return textCondition && dateCondition && (incompleteCondition ?? false)
                }
                
                return trackers.isEmpty ? nil : TrackerCategory(title: category.title, trackers: trackers)
            }
            
        default: break
        }
        
        collectionView.reloadData()
        updateVisibility()
    }
    
    func didTapCancelButton() {
        dismiss(animated: true)
    }
    
    private func saveTracker(_ tracker: Tracker, toCategory category: String) {
        do {
            if let existingCategory = categories.first(where: { $0.title == category }) {
                try trackerStore.addTracker(tracker, toCategory: existingCategory)
            } else {
                let newCategory = TrackerCategory(title: category, trackers: [tracker])
                try trackerStore.addTracker(tracker, toCategory: newCategory)
            }
        } catch {
            print("Ошибка сохранения трекера: \(error)")
        }
    }
    
    
    func didTapCreateButton(category: String, tracker: Tracker) {
        dismiss(animated: true)
        
        saveTracker(tracker, toCategory: category)
        
        reloadData()
        collectionView.reloadData()
        updateVisibility()
    }
    
    func didCreateTracker(with version: TrackerTypeViewController.TrackerVersion) {
        dismiss(animated: true)
        let createTracker = CreatingTrackerViewController(version: version)
        
        createTracker.delegate = self
        let navigationController = UINavigationController(rootViewController: createTracker)
        present(navigationController, animated: true)
    }
}

extension TrackersViewController {
    private func showDeleteAlert(tracker: Tracker) {
        let alert = UIAlertController(
            title: nil,
            message: NSLocalizedString("showDeleteAlert.text", comment: ""),
            preferredStyle: .actionSheet
        )
        let deleteButton = UIAlertAction(
            title: NSLocalizedString("delete.text", comment: ""),
            style: .destructive) { [weak self] _ in
                guard let self = self else { return }
                do {
                    try self.deleteTrackerInCategory(tracker: tracker)
                } catch {
                    print("Error deleting tracker: \(error)")
                }
            }
        let cencelButton = UIAlertAction(
            title: NSLocalizedString("cancelButton.text", comment: ""),
            style: .cancel
        )
        alert.addAction(deleteButton)
        alert.addAction(cencelButton)
        self.present(alert, animated: true)
    }
    
    private func deleteTrackerInCategory(tracker: Tracker) throws {
        do {
            
            //            try trackerRecordStore.deleteAllRecordForID(for: tracker.id)
            trackerStore.deleteTrackers(tracker: tracker)
            try fetchCategories()
            //            reloadData()
            reloadFilteredCategories(text: searchField.text, date: currentDate)
            updateVisibility()
        } catch {
            print("Delete tracker is failed")
        }
    }
    
    private func fetchCategories() throws {
        do {
            categories = try trackerCategoryStore.getCategories()
            reloadPinTrackers()
        } catch {
            assertionFailure("Failed to get categories with \(error)")
        }
    }
    
    func trackerDidSaved() {
        print("save")
    }
//    
//    func updateTracker(tracker: Tracker, to category: String) {
//        print("Updated")
//        do {
//            if let existingCategory = categories.first(where: { $0.title == category }) {
//                try? trackerStore.updateTracker(tracker, to: existingCategory)
//                try? fetchCategories()
//                reloadFilteredCategories(text: searchField.text, date: currentDate)
//            } else {
//                let newCategory = TrackerCategory(title: category, trackers: [tracker])
//                try trackerStore.addTracker(tracker, toCategory: newCategory)
//                try? trackerStore.updateTracker(tracker, to: newCategory)
//                try? fetchCategories()
//                reloadFilteredCategories(text: searchField.text, date: currentDate)
//            }
//            
//        } catch {
//            print("Ошибка сохранения трекера: \(error)")
//        }
//        
//    }
    
    func findCategoryByTracker(tracker: Tracker) throws -> TrackerCategory? {
         try trackerCategoryStore.getCategories()
            .first(where: {category in
                category.trackers.contains(where: { $0.id == tracker.id})
            })
    }
    
    private func pinTracker(_ tracker: Tracker) throws {
        do {
            try trackerStore.pinTrackerCoreData(tracker)
            try fetchCategories()
            reloadFilteredCategories(text: searchField.text, date: currentDate)
        } catch {
            print("Pin tracker failed")
        }
    }
    
    private func reloadPinTrackers() {
        categories = []
        var pinnedTrackers: [Tracker] = []
        
        for category in trackerCategoryStore.trackerCategory {
            let trackers = category.trackers
            let pinnedTrackersForCategory = trackers.filter { $0.isPinned }
            let unpinnedTrackers = trackers.filter { !$0.isPinned }
            pinnedTrackers.append(contentsOf: pinnedTrackersForCategory)
            
            if !unpinnedTrackers.isEmpty {
                let unpinnedCategory = TrackerCategory(title: category.title, trackers: unpinnedTrackers)
                categories.append(unpinnedCategory)
            }
        }
        
        if !pinnedTrackers.isEmpty {
            let pinnedCategory = TrackerCategory(
                title: NSLocalizedString("pinnedTrackers.title", comment: ""),
                trackers: pinnedTrackers)
            categories.insert(pinnedCategory, at: 0)
        }
        
    }
}

extension TrackersViewController: TrackerCellDelegate {
    func updateTrackerPinAction(tracker: Tracker) {
        try? self.pinTracker(tracker)
    }
    
    func editTrackerAction(tracker: Tracker) {
//        self.editingTrackers(tracker: tracker)
    }
    
    func deleteTrackerAction(tracker: Tracker) {
        self.showDeleteAlert(tracker: tracker)
    }
    
    
    func didTapDoneButton(cell: TrackerCell, with tracker: Tracker) {
        if isEnableToAdd {
            if let index = completedTrackers.firstIndex(where: { Calendar.current.isDate($0.date, inSameDayAs: currentDate)/*$0.date == currentDate*/ && $0.idRecord == tracker.id }) {
                do {
                    try trackerRecordStore.deleteRecord(with: tracker.id, by: currentDate)
                    completedTrackers.remove(at: index)
                    cell.changeImageButton(active: false)
                    cell.addOrSubtrack(value: false)
                } catch {
                    print("Remove task failed: \(error)")
                }
                
            } else {
                do {
                    try trackerRecordStore.addRecord(with: tracker.id, by: currentDate)
                    
                    let trackerRecord = TrackerRecord(idRecord: tracker.id, date: currentDate)
                    completedTrackers.append(trackerRecord)
                    cell.changeImageButton(active: true)
                    cell.addOrSubtrack(value: true)
                } catch {
                    print("Complete task failed")
                }
            }
        } else {
            let alert = UIAlertController(title: "\u{1F974}", message: NSLocalizedString("alert.description", comment: ""), preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: NSLocalizedString("alert.okay", comment: ""), style: .default, handler: nil))
            present(alert, animated: true, completion: nil)
        }
        updateVisibility()
    }
}

extension TrackersViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return filteredCategories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return filteredCategories[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let tracker = filteredCategories[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.idRecord == tracker.id }.count
        let active = completedTrackers.contains { Calendar.current.isDate($0.date, inSameDayAs: currentDate)/* $0.date == currentDate*/ && $0.idRecord == tracker.id }
        cell.configure(with: tracker, days: daysCount, active: active)
        cell.delegate = self
        return cell
    }
    
}

extension TrackersViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 16, left: geomentricParams.leftInset, bottom: 16, right: geomentricParams.rightInset)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let availableSpace = collectionView.frame.width - geomentricParams.paddingWidth
        let cellWidth = availableSpace / CGFloat(geomentricParams.cellCount)
        return CGSize(width: cellWidth, height: 148)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        geomentricParams.cellSpacing
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard
            kind == UICollectionView.elementKindSectionHeader,
            let view = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "header", for: indexPath) as? TrackerHeaderSectionView else { return UICollectionReusableView() }
        let label = filteredCategories[indexPath.section].title
        view.putText(label)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
    }
}

extension TrackersViewController: FiltersViewControllerDelegate {
    func filterSelected(filter: Filter) {
        selectedFilter = filter
        searchField.text = ""
        
        switch filter {
        case .all:
            filterButton.setTitleColor(.white_color, for: .normal)
            
        case .today:
            datePicker.setDate(Date(), animated: false)
            currentDate = datePicker.date
            filterButton.setTitleColor(.white_color, for: .normal)
            
        case .completed:
            filterButton.setTitleColor(.white_color, for: .normal)
            
        case .uncompleted:
            filterButton.setTitleColor(.white_color, for: .normal)
        }
        
        reloadFilteredCategories(text: searchField.text, date: currentDate)
    }
}

extension TrackersViewController {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        // Фильтрация трекеров по тексту
        reloadFilteredCategories(text: searchText, date: currentDate)
    }
}

struct GeometricParams {
    let cellCount: Int
    let leftInset: CGFloat
    let rightInset: CGFloat
    let cellSpacing: CGFloat
    let paddingWidth: CGFloat
    
    init(cellCount: Int, leftInset: CGFloat, rightInset: CGFloat, cellSpacing: CGFloat) {
        self.cellCount = cellCount
        self.leftInset = leftInset
        self.rightInset = rightInset
        self.cellSpacing = cellSpacing
        self.paddingWidth = leftInset + rightInset + CGFloat(cellCount - 1) * cellSpacing
    }
}


