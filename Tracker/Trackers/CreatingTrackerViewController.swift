//
//  CreatingTrackerViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 12.05.2024.
//

import Foundation
import UIKit

protocol CreatingTrackerViewControllerDelegate: AnyObject {
    func didTapCancelButton()
    func didTapCreateButton(category: String, tracker: Tracker)
}

final class CreatingTrackerViewController: UIViewController {
    
    let nameTracker = UITextField()
    let optionsTable = UITableView()
    let cancelButton = UIButton()
    let createButton = UIButton()
    let buttonStack = UIStackView()
    var isHabit = Bool()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white_color
        nameTracker.delegate = self
        optionsTable.dataSource = self
        optionsTable.delegate = self
        setTitle()
        setIsHabit()
        configureNameTracker()
        configureOptionsTable()
        configureButtonStack()
        configureCancelButton()
        configureCreateButton()
        
        checkButtonValidation()
        takeRandomElement()
    }
    private var messageHeightConstraint: NSLayoutConstraint?
    private var optionsTopConstraint: NSLayoutConstraint?
    
    private let parametres = ["Категория", "Расписание"]
    private let emoji = [
        "\u{1F600}", "\u{1F601}", "\u{1F602}", "\u{1F603}", "\u{1F604}", "\u{1F605}", "\u{1F606}", "\u{1F607}", "\u{1F608}", "\u{1F609}",
    ]
    private let trackerColors: [UIColor] = [.gray_color, .purple.withAlphaComponent(0.5), .red.withAlphaComponent(0.5), .blue.withAlphaComponent(0.5)]
    
    init(version: TrackerTypeViewController.TrackerVersion, data: Tracker.Track = Tracker.Track(), descr: TrackerCategory.TrackCategory = TrackerCategory.TrackCategory()) {
        self.version = version
        self.data = data
        self.descr = descr
        super.init(nibName: nil, bundle: nil)
        
        switch version {
        case .habit:
            self.data.schedule = []
        case .event:
            self.data.schedule = [getCurrentWeekday()]
        }
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
    
    private func configureNameTracker() {
        view.addSubview(nameTracker)
        nameTracker.translatesAutoresizingMaskIntoConstraints = false
        nameTracker.font = UIFont.systemFont(ofSize: 17, weight: .regular)
        nameTracker.backgroundColor = .background_color
        nameTracker.layer.cornerRadius = 16
        nameTracker.autocorrectionType = .yes
        nameTracker.placeholder = "Введите название трекера"
        nameTracker.addTarget(self, action: #selector(didChangeTextOnNameTracker), for: .editingChanged)
        
        let paddingView = UIView(frame: CGRect(x: 0, y: 0, width: 16, height: nameTracker.frame.height))
        nameTracker.leftView = paddingView
        nameTracker.leftViewMode = .always
        
        NSLayoutConstraint.activate([
            nameTracker.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            nameTracker.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            nameTracker.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            nameTracker.heightAnchor.constraint(equalToConstant: 75)
        ])
    }
    
    private func configureOptionsTable() {
        view.addSubview(optionsTable)
        optionsTable.translatesAutoresizingMaskIntoConstraints = false
        optionsTable.separatorStyle = .none
        optionsTable.isScrollEnabled = false
        optionsTable.register(CreatingCell.self, forCellReuseIdentifier: CreatingCell.identifier)
        
        NSLayoutConstraint.activate([
            optionsTable.topAnchor.constraint(equalTo: nameTracker.bottomAnchor, constant: 16),
            optionsTable.heightAnchor.constraint(equalToConstant: title == "Новая привычка" ? 150 : 75),
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
        cancelButton.setTitle("Отменить", for: .normal)
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
        createButton.setTitle("Создать", for: .normal)
        createButton.setTitleColor(.white, for: .normal)
        createButton.backgroundColor = .gray_color
        createButton.addTarget(self, action: #selector(didTapCreateButton), for: .touchUpInside)
        createButton.isEnabled = false
    }
    
    private func configureButtonStack() {
        view.addSubview(buttonStack)
        buttonStack.translatesAutoresizingMaskIntoConstraints = false
        buttonStack.spacing = 8
        buttonStack.axis = .horizontal
        buttonStack.distribution = .fillEqually
        
        NSLayoutConstraint.activate([
            buttonStack.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 20),
            buttonStack.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -20),
            buttonStack.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor),
            buttonStack.heightAnchor.constraint(equalToConstant: 60)
        ])
    }
    
    weak var delegate: CreatingTrackerViewControllerDelegate?
    private let version: TrackerTypeViewController.TrackerVersion
    private var data: Tracker.Track {
        didSet {
            checkButtonValidation()
        }
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
        guard let schedule = data.schedule else { return nil }
        if schedule.count == 7 { return "Каждый день" }
        let short: [String] = schedule.map { $0.shortDay }
        return short.joined(separator: ", ")
    }
    
    private var category: String? {
        guard let category = descr.title else { return nil }
        return category
    }
    
    private func setTitle() {
        switch version {
        case .habit:
            title = "Новая привычка"
        case .event:
            title = "Новое нерегулярное событие"
        }
    }
    
    private func setIsHabit() {
        switch version {
        case .habit:
            isHabit = true
        case .event:
            isHabit = false
        }
    }
    
    @objc private func didTapCancelButton() {
        delegate?.didTapCancelButton()
    }
    
    @objc private func didTapCreateButton() {
        guard let category = descr.title,
              let emoji = data.emoji,
              let color = data.color else { return }
        let createNewTracker = Tracker(id: UUID(), name: data.name, color: color, emoji: emoji, schedule: data.schedule)
        delegate?.didTapCreateButton(category: category, tracker: createNewTracker)
    }
    
    private func checkButtonValidation() {
        if data.name.count == 0 {
            buttonIsEnable = false
            return
        }
        
        if let schedule = data.schedule,
           schedule.isEmpty {
            buttonIsEnable = false
            return
        }
        buttonIsEnable = true
    }
    
    private func takeRandomElement() {
        data.emoji = emoji.randomElement()
        data.color = trackerColors.randomElement()
    }
    
    @objc private func didChangeTextOnNameTracker(_ sender: UITextField) {
        guard let text = sender.text else { return }
        data.name = text
    }
}



extension CreatingTrackerViewController: UITableViewDataSource {
    
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
            description = category
            position = .common
        } else {
            description = indexPath.row == 0 ? category : scheduleString
            position = indexPath.row == 0 ? .top : .bottom
        }
        cell.configure(name: parametres[indexPath.row], description: description, position: position)
        return cell
    }
}

extension CreatingTrackerViewController: UITableViewDelegate {
    
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

extension CreatingTrackerViewController: ScheduleViewControllerDelegate {
    func didRdy(activeDays: [WeekDay]) {
        data.schedule = activeDays
        optionsTable.reloadData()
        dismiss(animated: true)
    }
}

extension CreatingTrackerViewController: CategoryViewControllerDelegate {
    func didSelectCategory(category: TrackerCategory) {
        descr.title = category.title
        optionsTable.reloadData()
    }
}

extension CreatingTrackerViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        nameTracker.resignFirstResponder()
        return true
    }
}

