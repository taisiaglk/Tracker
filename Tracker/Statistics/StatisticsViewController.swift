//
//  StatisticsViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 08.05.2024.
//

import Foundation
import UIKit

struct Statistics {
    var title: String
    var count: String
}

final class StatisticsViewController: UIViewController {
    
    var categories: [TrackerCategory] = [TrackerCategory(title: "База", trackers: [])]
    private var completedTrackers: [TrackerRecord] = []
    private var statistics: [Statistics] = []
    
    private let trackerStore: TrackerStoreProtocol = TrackerStore.shared
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore.shared
    private let trackerRecordStore: TrackerRecordStoreProtocol = TrackerRecordStore.shared
    
    let titleHeader = UILabel()
    let collectionView = UICollectionView(frame: .zero, collectionViewLayout: UICollectionViewFlowLayout())
    let emptyScreenImage = UIImageView()
    let emptyStatisticsLabel = UILabel()
    
    private func configureTitleHeader() {
        view.addSubview(titleHeader)
        
        titleHeader.text = NSLocalizedString("statistics.title", comment: "")
        titleHeader.textColor = .black_color
        titleHeader.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        titleHeader.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            titleHeader.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 44),
            titleHeader.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16)
        ])
    }
    
    private func configureCollectionView() {
        view.addSubview(collectionView)
        
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.backgroundColor = .none
        collectionView.register(
            StatisticsCell.self,
            forCellWithReuseIdentifier: StatisticsCell.identifier)
        
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: titleHeader.bottomAnchor, constant: 77),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            collectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor)
        ])
    }
    
    private func configureEmptyScreenImage() {
        view.addSubview(emptyScreenImage)
        
        emptyScreenImage.image = UIImage(named: "sad")
        emptyScreenImage.contentMode = .scaleToFill
        emptyScreenImage.translatesAutoresizingMaskIntoConstraints = false
        emptyScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptyScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
        
        NSLayoutConstraint.activate([
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    private func configureEmptyStatisticsLabel() {
        view.addSubview(emptyStatisticsLabel)
        
        emptyStatisticsLabel.translatesAutoresizingMaskIntoConstraints = false
        emptyStatisticsLabel.text = NSLocalizedString("emptyStatistics.text", comment: "")
        emptyStatisticsLabel.numberOfLines = 0
        emptyStatisticsLabel.textColor = .black_color
        emptyStatisticsLabel.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        emptyStatisticsLabel.textAlignment = NSTextAlignment.center
        
        NSLayoutConstraint.activate([
            emptyStatisticsLabel.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            emptyStatisticsLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            emptyStatisticsLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
    
    func configureEmptyStatisticsScreen() {
        configureEmptyScreenImage()
        configureEmptyStatisticsLabel()
    }
    func configureFilledStatisticsScreen() {
        
        configureCollectionView()
        checkEmptyStatistics()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white_color
        try? fetchStatistics()
        configureTitleHeader()
        configureEmptyStatisticsScreen()
        configureFilledStatisticsScreen()
        checkEmptyStatistics()
        updateVisibility()
//        if completedTrackers.isEmpty {
//            configureEmptyStatisticsScreen()
//        } else {
//            configureFilledStatisticsScreen()
//            checkEmptyStatistics()
//        }
    }
    
    private func updateVisibility() {
        if completedTrackers.isEmpty {
            emptyScreenImage.isHidden = false
            emptyStatisticsLabel.isHidden = false
            collectionView.isHidden = true
        } else {
            emptyScreenImage.isHidden = true
            emptyStatisticsLabel.isHidden = true
            collectionView.isHidden = false
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        try? fetchStatistics()
        checkEmptyStatistics()
        updateVisibility()
    }
    
    private func checkEmptyStatistics() {
        collectionView.reloadData()
    }
    
    private func fetchStatistics() throws {
        do {
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
            
            getStatisticsCalculation()
        } catch {
            print("Fetch tracker record failed")
        }
    }
    
    private func getStatisticsCalculation() {
        if completedTrackers.isEmpty {
            statistics.removeAll()
        } else {
            statistics = [
                Statistics(
                    title: NSLocalizedString("getStatisticsCalculation.text", comment: ""),
                    count: "\(completedTrackers.count)")
            ]
        }
    }
}

extension StatisticsViewController: TrackerRecordStoreDelegate {
    func didUpdateData(in store: TrackerRecordStore) {
        try? fetchStatistics()
        checkEmptyStatistics()
    }
}

extension StatisticsViewController: UICollectionViewDelegate {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        sizeForItemAt indexPath: IndexPath
    ) -> CGSize {
        CGSize(width: collectionView.frame.width, height: 90)
    }
}

extension StatisticsViewController: UICollectionViewDataSource {
    func collectionView(
        _ collectionView: UICollectionView,
        numberOfItemsInSection section: Int
    ) -> Int {
        statistics.count
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        cellForItemAt indexPath: IndexPath
    ) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: StatisticsCell.identifier,
            for: indexPath
        ) as? StatisticsCell else {
            return UICollectionViewCell()
        }
        
        let newStatistics = statistics[indexPath.row]
        cell.configureCell(statistics: newStatistics)
        return cell
    }
}

extension StatisticsViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumLineSpacingForSectionAt section: Int
    ) -> CGFloat {
        20
    }
    
    func collectionView(
        _ collectionView: UICollectionView,
        layout collectionViewLayout: UICollectionViewLayout,
        minimumInteritemSpacingForSectionAt section: Int
    ) -> CGFloat {
        20
    }
}

