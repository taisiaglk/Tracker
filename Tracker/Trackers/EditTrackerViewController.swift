//
//  EditTrackerViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 17.06.2024.
//

import Foundation
import UIKit

protocol EditTrackerViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func updateTracker(tracker: Tracker, to category: TrackerCategory)
}

//enum TrackerVersion {
//    case habit, event
//}

final class EditTrackerViewController: UIViewController {
    
    private let trackerStore = TrackerStore.shared
    
    var delegate: EditTrackerViewControllerDelegate?
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    let nameTracker = UITextField()
    let optionsTable = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    let buttonStack = UIStackView()
    var isHabit = Bool()
    let completedDaysLabel = UILabel()
    
    let emojiAndColorCollectionView = UICollectionView(
        frame: .zero,
        collectionViewLayout: UICollectionViewFlowLayout()
    )
    
    var selectedEmoji: String?
    var selectedEmojiIndex: Int?
    var selectedColor: UIColor?
    var selectedColorIndex: Int?
    var editTracker: Tracker?
    var daysCount: Int?
    var category: String?
    var schedule: [WeekDay]?
    var selectedTrackerCategory: TrackerCategory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white_color
        nameTracker.delegate = self
        optionsTable.dataSource = self
        optionsTable.delegate = self
        emojiAndColorCollectionView.dataSource = self
        emojiAndColorCollectionView.delegate = self
        
        setTitle()
        setIsHabit()
        configureScrollView()
        configureContentView()
        configureCompletedDaysLabel()
        configureNameTracker()
        configureOptionsTable()
        configureEmojiAndColorCollectionView()
        configureButtonStack()
        configureCancelButton()
        configureCreateButton()
        checkButtonValidation()
        
        
        setupDataForEditing()
    }
    private var messageHeightConstraint: NSLayoutConstraint?
    private var optionsTopConstraint: NSLayoutConstraint?
    
    private let parametres = [NSLocalizedString("category.title", comment: ""), NSLocalizedString("schedule.title", comment: ""),]
    
    var emoji = [
        "🙂", "😻", "🌺", "🐶", "❤️", "😱",
        "😇", "😡", "🥶", "🤔", "🙌", "🍔",
        "🥦", "🏓", "🥇", "🎸", "🏝", "😪"
    ]
    
    private let trackerColors: [UIColor] =  [
        .colorr1, .colorr2, .colorr3, .colorr4, .colorr5, .colorr6,
        .colorr7, .colorr8, .colorr9, .colorr10, .colorr11, .colorr12,
        .colorr13, .colorr14, .colorr15, .colorr16, .colorr17, .colorr18
    ]
    
    init(tracker: Tracker, daysCount: Int, category: TrackerCategory, data: Tracker.Track = Tracker.Track(), descr: TrackerCategory.TrackCategory = TrackerCategory.TrackCategory()) {
        self.descr = descr
        self.data = data
        self.editTracker = tracker
        self.data.name = tracker.name
        self.data.schedule = tracker.schedule
        self.data.color = tracker.color
        self.data.emoji = tracker.emoji
        self.data.isPinned = tracker.isPinned
        
        self.descr.title = category.title
        self.descr.trackers = category.trackers
        self.selectedTrackerCategory = category
        super.init(nibName: nil, bundle: nil)
        self.daysCount = daysCount
        self.selectedTrackerCategory = category
        self.editTracker = tracker
        
    }
    
    private func getCurrentWeekday() -> WeekDay {
        let calendar = Calendar.current
        let weekdayIndex = calendar.component(.weekday, from: Date())
        return WeekDay(rawValue: weekdayIndex - 2) ?? .monday
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupDataForEditing() {
        guard let editTracker = editTracker else { return }
        nameTracker.text = editTracker.name
        selectedEmoji = editTracker.emoji
        selectedColor = editTracker.color
        schedule = editTracker.schedule
        
        if let emojiIndex = emoji.firstIndex(of: editTracker.emoji) {
            selectedEmojiIndex = emojiIndex
        }
        if let colorIndex = trackerColors.firstIndex(of: editTracker.color) {
            selectedColorIndex = colorIndex
        }
        
        optionsTable.reloadData()
        emojiAndColorCollectionView.reloadData()
    }
    
    private func configureScrollView() {
        view.addSubview(scrollView)
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.contentSize = CGSize(width: view.frame.width, height: view.frame.height + 200)
        scrollView.frame = view.bounds
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func configureContentView() {
        scrollView.addSubview(contentView)
        contentView.translatesAutoresizingMaskIntoConstraints = false
        contentView.frame.size = CGSize(width: view.frame.width, height: view.frame.height + 200)
        
        NSLayoutConstraint.activate([
            contentView.widthAnchor.constraint(equalTo: view.widthAnchor),
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
        ])
    }
    
    
    private func configureNameTracker() {
        scrollView.addSubview(nameTracker)
        nameTracker.translatesAutoresizingMaskIntoConstraints = false
        nameTracker.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameTracker.backgroundColor = .background_color
        nameTracker.layer.cornerRadius = 16
        nameTracker.autocorrectionType = .yes
        nameTracker.placeholder =  NSLocalizedString("newTrackerName.placeholder", comment: "")
        nameTracker.addTarget(self, action: #selector(didChangeTextOnNameTracker), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTracker.frame.height))
        nameTracker.leftView = paddingView
        nameTracker.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            nameTracker.topAnchor.constraint(equalTo: completedDaysLabel.bottomAnchor, constant: 40),
            nameTracker.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTracker.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTracker.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func configureCompletedDaysLabel() {
        scrollView.addSubview(completedDaysLabel)
        completedDaysLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        completedDaysLabel.text = String.localizedStringWithFormat(NSLocalizedString("numberOfDays", comment: "numberOfDays"), daysCount ?? 0)
        completedDaysLabel.textAlignment = .center
        completedDaysLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            completedDaysLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24),
            completedDaysLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            completedDaysLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            completedDaysLabel.heightAnchor.constraint(equalToConstant: 38)
        ])
        
        
    }
    
    private func configureOptionsTable() {
        scrollView.addSubview(optionsTable)
        optionsTable.translatesAutoresizingMaskIntoConstraints = false
        optionsTable.separatorStyle = .none
        optionsTable.isScrollEnabled = false
        optionsTable.register(CreatingCell.self, forCellReuseIdentifier: CreatingCell.identifier)
        
        NSLayoutConstraint.activate([
            optionsTable.topAnchor.constraint(equalTo: nameTracker.bottomAnchor, constant: 16),
            optionsTable.heightAnchor.constraint(equalToConstant: title == NSLocalizedString("newHabit.title", comment: "") ? 150 : 75),
            optionsTable.leadingAnchor.constraint(equalTo: nameTracker.leadingAnchor),
            optionsTable.trailingAnchor.constraint(equalTo: nameTracker.trailingAnchor)
        ])
    }
    
    private func configureCancelButton() {
        buttonStack.addArrangedSubview(cancelButton)
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        cancelButton.layer.cornerRadius = 16
        cancelButton.layer.masksToBounds = true
        cancelButton.setTitle(NSLocalizedString("cancelButton.text", comment: ""), for: .normal)
        cancelButton.setTitleColor(.red_color, for: .normal)
        cancelButton.backgroundColor = .white_color
        cancelButton.layer.borderWidth = 1
        cancelButton.layer.borderColor = UIColor.red_color.cgColor
        cancelButton.addTarget(self, action: #selector(didTapCancelButton), for: .touchUpInside)
    }
    
    private func configureCreateButton() {
        buttonStack.addArrangedSubview(createButton)
        createButton.translatesAutoresizingMaskIntoConstraints = false
        createButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        createButton.layer.cornerRadius = 16
        createButton.layer.masksToBounds = true
        createButton.setTitle(NSLocalizedString("createButton.text", comment: ""), for: .normal)
        createButton.setTitleColor(.white_color, for: .normal)
        createButton.backgroundColor = .gray_color
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createButton.isEnabled = false
    }
    
    private func configureButtonStack() {
        scrollView.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 8
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            buttonStack.topAnchor.constraint(equalTo: emojiAndColorCollectionView.bottomAnchor, constant: 16),
            buttonStack.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    private func configureEmojiAndColorCollectionView() {
        scrollView.addSubview(emojiAndColorCollectionView)
        emojiAndColorCollectionView.translatesAutoresizingMaskIntoConstraints = false
        emojiAndColorCollectionView.backgroundColor = .white_color
        emojiAndColorCollectionView.isScrollEnabled = false
        emojiAndColorCollectionView.register(EmojiAndColorCell.self, forCellWithReuseIdentifier: EmojiAndColorCell.reuseIdentifier)
        emojiAndColorCollectionView.register(EmojiAndColorHeaderSectionView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: EmojiAndColorHeaderSectionView.reuseIdentifier)
        
        NSLayoutConstraint.activate([
            emojiAndColorCollectionView.topAnchor.constraint(equalTo: optionsTable.bottomAnchor, constant: 32),
            emojiAndColorCollectionView.leadingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.leadingAnchor),
            emojiAndColorCollectionView.trailingAnchor.constraint(equalTo: contentView.safeAreaLayoutGuide.trailingAnchor),
            emojiAndColorCollectionView.heightAnchor.constraint(equalToConstant: 460)
        ])
    }
    
    private var descr: TrackerCategory.TrackCategory {
        didSet {
            checkButtonValidation()
        }
    }
    
    private var buttonIsEnable = false {
        willSet {
            if newValue {
                createButton.backgroundColor = .black_color
                createButton.setTitleColor(.white_color, for: .normal)
                createButton.isEnabled = true
            } else {
                createButton.backgroundColor = .gray_color
                createButton.setTitleColor(.white, for: .normal)
                createButton.isEnabled = false
            }
        }
    }
    
    private var scheduleString: String? {
        guard let schedule = schedule else { return nil }
        if schedule.count == 7 { return NSLocalizedString("everyDay.text", comment: "") }
        let short: [String] = schedule.map { $0.shortDay }
        return short.joined(separator: ", ")
    }
    
    private func setTitle() {
        title = NSLocalizedString("editTracker.title", comment: "")
    }
    
    private func setIsHabit() {
        if let editTracker = editTracker {
            if !((editTracker.schedule?.isEmpty) != nil) {
                isHabit = false
            } else {
                isHabit = true
            }
        } else {
            isHabit = false
        }
    }
    
    @objc private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    private var data: Tracker.Track {
        didSet {
            checkButtonValidation()
        }
    }
    
    @objc private func didTapCreateButton() {
        let createNewTracker = Tracker(id: editTracker!.id, name: data.name, color: selectedColor ?? .colorr1, emoji: selectedEmoji ?? "🙂", schedule: data.schedule, isPinned: editTracker?.isPinned ?? false)
        guard let selectedTrackerCategory = selectedTrackerCategory else {
            return
        }
        delegate?.updateTracker(tracker: createNewTracker, to: selectedTrackerCategory)
        
        
    }
    
    private let trackerCategoryStore: TrackerCategoryStoreProtocol = TrackerCategoryStore.shared
    
    func findCategoryByTracker(tracker: Tracker) throws -> TrackerCategory? {
        try trackerCategoryStore.getCategories()
            .first(where: {category in
                category.trackers.contains(where: { $0.id == tracker.id})
            })
    }
    
    private func checkButtonValidation() {
        if editTracker?.name.count == 0 {
            buttonIsEnable = false
            return
        }
        
        if let schedule = schedule,
           schedule.isEmpty {
            buttonIsEnable = false
            return
        }
        buttonIsEnable = true
    }
    
    @objc private func didChangeTextOnNameTracker(_ sender: UITextField) {
        guard let text = sender.text else { return }
        data.name = text
    }
}

extension EditTrackerViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isHabit {
            return 2
        } else {
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CreatingCell.identifier) as? CreatingCell else { return UITableViewCell() }
        
        var description: String? = nil
        var position: CommonCellView.Position
        
        if !isHabit {
            description = descr.title
            position = .common
        } else {
            description = indexPath.row == 0 ? descr.title : scheduleString
            position = indexPath.row == 0 ? .top : .bottom
        }
        cell.configure(name: parametres[indexPath.row], description: description, position: position)
        return cell
    }
}

extension EditTrackerViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if isHabit {
            if indexPath.row != 0 {
                guard let schedule = data.schedule else { return }
                let scheduleViewController = ScheduleViewController(markedWeekdays: schedule)
                scheduleViewController.delegate = self
                let navigationController = UINavigationController(rootViewController: scheduleViewController)
                present(navigationController, animated: true)
            } else {
                let categoryViewController = CategoryViewController()
                categoryViewController.delegate = self
                navigationController?.pushViewController(categoryViewController, animated: true)
            }
        } else {
            let categoryViewController = CategoryViewController()
            categoryViewController.delegate = self
            navigationController?.pushViewController(categoryViewController, animated: true)
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension EditTrackerViewController: ScheduleViewControllerDelegate {
    func didRdy(activeDays: [WeekDay]) {
        data.schedule = activeDays
        optionsTable.reloadData()
        dismiss(animated: true)
    }
}

extension EditTrackerViewController: CategoryViewControllerDelegate {
    func didSelectCategory(category: TrackerCategory) {
        descr.title = category.title
        self.selectedTrackerCategory = category
//        self.selectedTrackerCategory?.title = TrackerCategory.TrackCategory().title ?? ""
//        self.selectedTrackerCategory?.trackers = TrackerCategory.TrackCategory().trackers
        optionsTable.reloadData()
    }
}

extension EditTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTracker.resignFirstResponder()
        return true
    }
}

extension EditTrackerViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        switch section {
        case 0:
            return emoji.count
        case 1:
            return trackerColors.count
        default:
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EmojiAndColorCell.reuseIdentifier, for: indexPath) as? EmojiAndColorCell else { return UICollectionViewCell() }
        
        switch indexPath.section {
        case 0:
            let emoji = emoji[indexPath.row]
            cell.titleLabel.text = emoji
            
            if emoji == selectedEmoji {
                setEmojiHighlight(indexPath, collectionView, cell)
            }
        case 1:
            let color = trackerColors[indexPath.row]
            cell.titleLabel.backgroundColor = color
            
            let cellColor = color.hexString()
            
            if let editTrackerColor = editTracker?.color {
                let selectedColor = editTrackerColor.hexString()
                if cellColor == selectedColor {
                    setColorHighlight(indexPath, collectionView, cell)
                }
            }
        default:
            break
        }
        
        cell.titleLabel.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        
        return cell
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        guard let view = collectionView.dequeueReusableSupplementaryView(
            ofKind: kind,
            withReuseIdentifier: EmojiAndColorHeaderSectionView.reuseIdentifier,
            for: indexPath
        ) as? EmojiAndColorHeaderSectionView else { return UICollectionReusableView() }
        
        switch indexPath.section {
        case 0:
            view.titleLabel.text = "Emoji"
        case 1:
            view.titleLabel.text = NSLocalizedString("color.title", comment: "")
        default:
            return UICollectionReusableView()
        }
        return view
        
    }
}

extension EditTrackerViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 52, height: 52)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 24, left: 18, bottom: 40, right: 18)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let indexPath = IndexPath(row: 0, section: section)
        let headerView = self.collectionView(collectionView, viewForSupplementaryElementOfKind: UICollectionView.elementKindSectionHeader, at: indexPath)
        return headerView.systemLayoutSizeFitting(
            CGSize(
                width: collectionView.frame.width,
                height: UIView.layoutFittingExpandedSize.height
            ),
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .fittingSizeLevel
        )
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        switch indexPath.section {
            
        case 0:
            if let selectedEmojiIndex = selectedEmojiIndex {
                let previousSelectedIndexPath = IndexPath(item: selectedEmojiIndex, section: 0)
                if let cell = collectionView.cellForItem(at: previousSelectedIndexPath) as? EmojiAndColorCell {
                    cell.backgroundColor = .clear
                }
            }
            setEmojiHighlight(indexPath, collectionView)
            
        case 1:
            if let selectedColorIndex = selectedColorIndex {
                let previousSelectedIndexPath = IndexPath(item: selectedColorIndex, section: 1)
                if let cell = collectionView.cellForItem(at: previousSelectedIndexPath) as? EmojiAndColorCell {
                    cell.layer.borderColor = UIColor.clear.cgColor
                    cell.layer.borderWidth = 0
                }
            }
            setColorHighlight(indexPath, collectionView)
            
        default:
            return
        }
        checkButtonValidation()
    }
    
    func setEmojiHighlight(_ indexPath: IndexPath, _ collectionView: UICollectionView, _ existsCell: EmojiAndColorCell? = nil) {
        guard let cell = existsCell ?? collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell else { return }
        cell.layer.cornerRadius = 16
        cell.layer.masksToBounds = true
        cell.backgroundColor = .gray_color
        selectedEmoji = emoji[indexPath.row]
        selectedEmojiIndex = indexPath.row
    }
    
    func setColorHighlight(_ indexPath: IndexPath, _ collectionView: UICollectionView, _ existsCell: EmojiAndColorCell? = nil) {
        guard let cell = existsCell ?? collectionView.cellForItem(at: indexPath) as? EmojiAndColorCell else { return }
        cell.layer.cornerRadius = 8
        cell.layer.masksToBounds = true
        cell.layer.borderColor = trackerColors[indexPath.row].cgColor.copy(alpha: 0.3)
        cell.layer.borderWidth = 3
        selectedColor = trackerColors[indexPath.row]
        selectedColorIndex = indexPath.row
    }
}
