//
//  FiltersViewController.swift
//  Tracker
//
//  Created by Тася Галкина on 14.06.2024.
//

import Foundation
import UIKit

protocol FiltersViewControllerDelegate: AnyObject {
    func filterSelected(filter: Filter)
}
final class FiltersViewController: UIViewController {
    
    var selectedFilter: Filter?
    weak var delegate: FiltersViewControllerDelegate?
    
    private let filters: [Filter] = Filter.allCases
    
    let filterLabel = UILabel()
    let tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white_color
        
        configureFilterLabel()
        configureTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    private func configureFilterLabel() {
        view.addSubview(filterLabel)
        
        filterLabel.text = NSLocalizedString("filters.title", comment: "")
        filterLabel.textColor = .black_color
        filterLabel.font = .systemFont(ofSize: 16, weight: .medium)
        filterLabel.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            filterLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            filterLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 27)
        ])
    }
    
    private func configureTableView() {
        view.addSubview(tableView)
        
        tableView.layer.cornerRadius = 16
        tableView.layer.masksToBounds = true
        tableView.isScrollEnabled = false
        tableView.backgroundColor = .white_color
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .singleLine
        tableView.separatorColor = .gray_color
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: filterLabel.bottomAnchor, constant: 38),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tableView.heightAnchor.constraint(equalToConstant: 298)
        ])
    }
}

extension FiltersViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filters.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let filter = filters[indexPath.row]
        cell.textLabel?.text = filter.rawValue
        cell.backgroundColor = .gray_color.withAlphaComponent(0.3)
        cell.accessoryType = filter == selectedFilter ? .checkmark : .none
        return cell
    }
}

extension FiltersViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let previousSelectedCell = tableView.cellForRow(at: indexPath)
        previousSelectedCell?.accessoryType = .none
        let cell = tableView.cellForRow(at: indexPath)
        cell?.accessoryType = .checkmark
        tableView.deselectRow(at: indexPath, animated: true)
        let filter = filters[indexPath.row]
        delegate?.filterSelected(filter: filter)
        dismiss(animated: true)
    }
}
