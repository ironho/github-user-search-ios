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
    
    let viewModel: UserListViewModel

    
    // MARK: - UI
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
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    
    // MARK: - Life cycle
    init(viewModel: UserListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupNavigationBarAppearance()
        setupViews()
    }
}


// MARK: - Setup
extension UserListViewController {
    
    func setupNavigationBarAppearance() {
        let appearance = UINavigationBarAppearance().then {
            $0.backgroundColor = .purple
            $0.titleTextAttributes = [.foregroundColor: UIColor.white]
            $0.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        }
        
        navigationController?.navigationBar.do {
            $0.tintColor = .white
            $0.standardAppearance = appearance
            $0.compactAppearance = appearance
            $0.scrollEdgeAppearance = appearance
        }
    }
    
    private func setupViews() {
        navigationItem.title = "Github"
        
        searchContainer.addSubview(searchController.searchBar)
        view.do {
            $0.addSubview(searchContainer)
            $0.addSubview(tableView)
        }

        searchContainer.do {
            $0.left == view.left
            $0.right == view.right
            $0.top == view.safeAreaLayoutGuide.top
            $0.height == 56.0
        }
        
        tableView.do {
            $0.left == view.left
            $0.right == view.right
            $0.top == searchContainer.bottom
            $0.bottom == view.safeAreaLayoutGuide.bottom
        }
    }
    
}


// MARK: - UISearchBarDelegate
extension UserListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        searchController.isActive = false
        viewModel.didSearch(string: searchText)
    }
    
}


// MARK: - UISearchControllerDelegate
extension UserListViewController: UISearchControllerDelegate {
    
}
