//
//  CategoryViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 14.05.2024.
//

import Foundation
import UIKit

protocol CategoryViewControllerDelegate {
    func didSelectCategory(category: TrackerCategory)
}

final class CategoryViewController: UIViewController {
    
    var delegate: CategoryViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white_color
        
        navigationItem.hidesBackButton = true
        navigationItem.title = "Категория"
        
        configureLabel()
        configureEmptyScreenImage()
        configureAddButton()
        configureTableView()
        setupConstraints()
        updateVisibility()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private var trackerCategories: [TrackerCategory] = []
    private var selectedCategoryIndex = -1
    
    let categoryTable = UITableView()
    let label = UILabel()
    let addButton = UIButton()
    let emptyScreenImage = UIImageView()
    let tableView = UITableView()
    
    private func configureEmptyScreenImage() {
        view.addSubview(emptyScreenImage)
        emptyScreenImage.image = UIImage(named: "star")
        emptyScreenImage.contentMode = .scaleToFill
        emptyScreenImage.translatesAutoresizingMaskIntoConstraints = false
        emptyScreenImage.heightAnchor.constraint(equalToConstant: 80).isActive = true
        emptyScreenImage.widthAnchor.constraint(equalToConstant: 80).isActive = true
    }
    
    private func configureLabel() {
        view.addSubview(label)
        label.translatesAutoresizingMaskIntoConstraints = false
        label.text = "Привычки и события можно \nобъединить по смыслу"
        label.numberOfLines = 0
        label.textColor = .black_color
        label.font = UIFont.systemFont(ofSize: 12, weight: .medium)
        label.textAlignment = NSTextAlignment.center
    }
    
    private func configureAddButton() {
        view.addSubview(addButton)
        addButton.translatesAutoresizingMaskIntoConstraints = false
        addButton.backgroundColor = .black_color
        addButton.layer.cornerRadius = 16
        addButton.layer.masksToBounds = true
        addButton.setTitle("Добавить категорию", for: .normal)
        addButton.setTitleColor(.white, for: .normal)
        addButton.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        addButton.addTarget(self, action: #selector(pushAddCategoryButton), for: .touchUpInside)
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.tableHeaderView = UIView()
        tableView.separatorStyle = .none
        tableView.register(CategoryCell.self, forCellReuseIdentifier: CategoryCell.identifier)
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            
            emptyScreenImage.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            emptyScreenImage.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            label.topAnchor.constraint(equalTo: emptyScreenImage.bottomAnchor, constant: 8),
            label.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor, constant: -16),
            
            addButton.heightAnchor.constraint(equalToConstant: 60),
            addButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            addButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            addButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.bottomAnchor.constraint(equalTo: addButton.topAnchor, constant: -24),
        ])
    }
    
    @objc private func pushAddCategoryButton() {
        let newCategoryViewController = NewCategoryViewController()
        newCategoryViewController.delegate = self
        let navigationController = UINavigationController(rootViewController: newCategoryViewController)
        present(navigationController, animated: true)
    }
    
    private func updateVisibility() {
        if trackerCategories.isEmpty {
            emptyScreenImage.isHidden = false
            label.isHidden = false
            tableView.isHidden = true
        } else {
            emptyScreenImage.isHidden = true
            label.isHidden = true
            tableView.isHidden = false
        }
    }
    
    private func createSeparator() -> UIView {
        let separator = UIView()
        separator.backgroundColor = .gray_color
        separator.translatesAutoresizingMaskIntoConstraints = false
        return separator
    }
}

extension CategoryViewController: NewCategoryViewControllerDelegate {
    
    func didCreateCategory(_ category: TrackerCategory) {
        trackerCategories.append(category)
        updateVisibility()
        tableView.reloadData()
    }
    
}

extension CategoryViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return trackerCategories.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: CategoryCell.identifier) as? CategoryCell else { return UITableViewCell() }
        
        cell.configure(name: trackerCategories[indexPath.row].title)
        
        var position: CommonCellView.Position
        
        switch indexPath.row {
        case 0:
            position = .top
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        case trackerCategories.count - 1:
            position = .bottom
            cell.layer.cornerRadius = 16
            cell.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        default:
            position = .middle
            cell.layer.cornerRadius = 0
        }
        
        if trackerCategories.count == 1 {
            cell.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner, .layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        }
        
        cell.backgroundColor = .background_color
        
        if indexPath.row < trackerCategories.count - 1 {
            let separator = createSeparator()
            cell.contentView.addSubview(separator)
            NSLayoutConstraint.activate([
                separator.leadingAnchor.constraint(equalTo: cell.contentView.leadingAnchor, constant: 16),
                separator.trailingAnchor.constraint(equalTo: cell.contentView.trailingAnchor, constant: -16),
                separator.bottomAnchor.constraint(equalTo: cell.contentView.bottomAnchor),
                separator.heightAnchor.constraint(equalToConstant: 0.5)
            ])
        }
        
        if indexPath.row == selectedCategoryIndex {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
}

extension CategoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        selectedCategoryIndex = indexPath.row
        tableView.reloadData()
        
        let selectedCategory = trackerCategories[indexPath.row]
        delegate?.didSelectCategory(category: selectedCategory)
        navigationController?.popViewController(animated: true)
    }
}

