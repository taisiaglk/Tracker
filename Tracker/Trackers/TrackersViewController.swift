//
//  TrackersViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 08.05.2024.
//

import Foundation
import UIKit

class TrackersViewController: UIViewController, TrackerTypeViewControllerDelegate, UICollectionViewDelegate, UISearchBarDelegate, CreatingTrackerViewControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        reloadData()
        addToScreen()
        collectionView.dataSource = self
        collectionView.delegate = self
        searchField.delegate = self
    }
    
    var categories: [TrackerCategory] = [TrackerCategory(title: "База", trackers: [])]
    var completedTrackers: [TrackerRecord] = []
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore.shared
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore.shared
    private let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore.shared
    
    private var addButton = UIButton()
    private var starImage = UIImageView()
    private var label = UILabel()
    private var trackersLabel = UILabel()
    let searchField = UISearchBar()
    let datePicker = UIDatePicker()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    
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
        trackersLabel.textColor = .black
        NSLayoutConstraint.activate([
            trackersLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            trackersLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.setImage(UIImage(named: "AddTracker"), for: .normal)
        addButton.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
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
    
    private func addToScreen() {
        configureTrackersLabel()
        configureAddButton()
        configureSearchField()
        configureDatePicker()
        configureCollectionView()
        configureStarImage()
        configureLabel()
        updateVisibility()
    }
    
    private func updateVisibility() {
        if currentlyTrackers.isEmpty {
            starImage.isHidden = false
            label.isHidden = false
            collectionView.isHidden = true
        } else {
            starImage.isHidden = true
            label.isHidden = true
            collectionView.isHidden = false
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
    }
    
    private func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
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

extension TrackersViewController: TrackerCellDelegate {
    func didTapDoneButton(cell: TrackerCell, with tracker: Tracker) {
        if isEnableToAdd {
            let recordingTracker = TrackerRecord(idRecord: tracker.id, date: currentDate)
            if let index = completedTrackers.firstIndex(where: { $0.date == currentDate && $0.idRecord == tracker.id }) {
                completedTrackers.remove(at: index)
                cell.changeImageButton(active: false)
                cell.addOrSubtrack(value: false)
            } else {
                completedTrackers.append(recordingTracker)
                cell.changeImageButton(active: true)
                cell.addOrSubtrack(value: true)
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
        return currentlyTrackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return currentlyTrackers[section].trackers.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: TrackerCell.identifier, for: indexPath) as? TrackerCell else {
            return UICollectionViewCell()
        }
        let tracker = currentlyTrackers[indexPath.section].trackers[indexPath.row]
        let daysCount = completedTrackers.filter { $0.idRecord == tracker.id }.count
        let active = completedTrackers.contains { $0.date == currentDate && $0.idRecord == tracker.id }
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
        let label = currentlyTrackers[indexPath.section].title
        view.putText(label)
        return view
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(CGSize(width: collectionView.frame.width, height: UIView.layoutFittingExpandedSize.height), withHorizontalFittingPriority: .required, verticalFittingPriority: .fittingSizeLevel)
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
