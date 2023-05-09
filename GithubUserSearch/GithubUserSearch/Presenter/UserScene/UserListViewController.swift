//
//  UserListViewController.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import UIKit

import SuperEasyLayout
import Then

class UserListViewController: UIViewController {
    
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.delegate = self
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = "유저 검색"
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.translatesAutoresizingMaskIntoConstraints = true
        $0.searchBar.barStyle = .default
        $0.hidesNavigationBarDuringPresentation = false
        $0.searchBar.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 56))
        definesPresentationContext = true
    }
    
    private lazy var searchContainer = UIView().then { _ in
    }
    
    private lazy var tableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupViews()
    }
}


// MARK: - Setup
extension UserListViewController {
    
    private func setupViews() {
        navigationItem.title = "Github"
        
        searchContainer.addSubview(searchController.searchBar)
        view.addSubview(searchContainer)
        view.addSubview(tableView)
        
        tableView.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)

        searchContainer.left == view.left
        searchContainer.right == view.right
        searchContainer.top == view.safeAreaLayoutGuide.top
        searchContainer.height == 56.0
        
        tableView.left == view.left
        tableView.right == view.right
        tableView.top == searchContainer.bottom
        tableView.bottom == view.safeAreaLayoutGuide.bottom
    }
    
}


// MARK: - UISearchBarDelegate
extension UserListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        // TODO: Search with searchText
    }
    
}


// MARK: - UISearchControllerDelegate
extension UserListViewController: UISearchControllerDelegate {
    
}
