//
//  UserListViewController.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import UIKit
import SafariServices

import RxSwift
import SuperEasyLayout
import Then

class UserListViewController: UIViewController {
    
    let viewModel: UserListViewModel

    
    // MARK: - UI
    private lazy var searchController = UISearchController(searchResultsController: nil).then {
        $0.delegate = self
        $0.searchBar.delegate = self
        $0.searchBar.placeholder = "유저 검색"
        $0.searchBar.searchTextField.clearButtonMode = .never
        $0.searchBar.showsCancelButton = false
        $0.obscuresBackgroundDuringPresentation = false
        $0.searchBar.translatesAutoresizingMaskIntoConstraints = true
        $0.searchBar.barStyle = .default
        $0.hidesNavigationBarDuringPresentation = false
        $0.searchBar.frame = CGRect(origin: .zero, size: CGSize(width: UIScreen.main.bounds.width, height: 56))
        definesPresentationContext = true
    }
    
    private lazy var searchContainer = UIView()
    
    private lazy var tableView = UITableView().then {
        $0.rowHeight = UITableView.automaticDimension
        $0.estimatedRowHeight = UITableView.automaticDimension
        $0.separatorInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        $0.register(UserListCell.self, forCellReuseIdentifier: "Cell")
        $0.keyboardDismissMode = .onDrag
    }
    
    private lazy var emptyLabel = UILabel().then {
        $0.font = UIFont.preferredFont(forTextStyle: .body)
        $0.text = "검색된 유저가 없습니다"
        $0.textAlignment = .center
    }
    
    private lazy var searchClearButton = UIButton().then {
        $0.setImage(UIImage(systemName: "xmark.circle"), for: .normal)
        $0.tintColor = .lightGray
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
        setupAuthorizeToggleButton()
        setupViews()
        
        bindItems()
        bindItemSelected()
        bindRefreshControl()
        bindPagination()
        bindEmptyView()
        bindClearButton()
        bindIsLoading()
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
    
    private func setupAuthorizeToggleButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Sign in", style: .plain, target: self, action: #selector(authorizeToggleButtonTapped))
    }
    
    private func setupViews() {
        navigationItem.title = "Github"
        
        searchContainer.addSubview(searchController.searchBar)
        searchController.searchBar.addSubview(searchClearButton)
        view.do {
            $0.addSubview(searchContainer)
            $0.addSubview(tableView)
            $0.addSubview(emptyLabel)
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
        
        emptyLabel.do {
            $0.centerX == tableView.centerX
            $0.centerY == tableView.centerY
        }
        
        searchClearButton.do {
            $0.centerY == searchController.searchBar.centerY
            $0.right == searchController.searchBar.right - 16
        }
    }
    
}


// MARK: - Bind
extension UserListViewController {
    
    private func bindItems() {
        viewModel.items.bind(to: tableView.rx.items(cellIdentifier: "Cell", cellType: UserListCell.self)) { (row, element, cell) in
            cell.user = element
        }
        .disposed(by: rx.disposeBag)
    }
    
    private func bindItemSelected() {
        tableView.rx.modelSelected(User.self)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, model) in
                if let selectedRowIndexPath = owner.tableView.indexPathForSelectedRow {
                    owner.tableView.deselectRow(at: selectedRowIndexPath, animated: true)
                }
                guard let url = URL(string: model.html_url) else { return }
                let safariViewController = SFSafariViewController(url: url)
                owner.present(safariViewController, animated: true)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func bindRefreshControl() {
        let refreshControl = UIRefreshControl()
        tableView.refreshControl = refreshControl
        refreshControl.rx.controlEvent(.valueChanged)
            .observe(on: MainScheduler.instance)
            .map { refreshControl.isRefreshing }
            .filter { $0 == true }
            .withUnretained(self)
            .subscribe( onNext: {
                $0.0.viewModel.didSearch(string: $0.0.viewModel.query.value)
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func bindPagination() {
        tableView.rx.didScroll
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .throttle(.milliseconds(50), scheduler: MainScheduler.instance)
            .filter {
                !$0.0.viewModel.isLoading.value
            }
            .filter {
                !$0.0.viewModel.isPagingEnded.value
            }
            .filter {
                $0.0.tableView.isNeedPagination()
            }
            .subscribe(onNext: {
                $0.0.viewModel.loadNextPage()
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func bindEmptyView() {
        viewModel.isEmpty
            .observe(on: MainScheduler.instance)
            .map { !$0 }
            .bind(to: emptyLabel.rx.isHidden)
            .disposed(by: rx.disposeBag)
    }
    
    private func bindClearButton() {
        searchController.searchBar.rx.text
            .observe(on: MainScheduler.instance)
            .map { $0 == "" }
            .bind(to: searchClearButton.rx.isHidden)
            .disposed(by: rx.disposeBag)
        
        searchClearButton.rx.tap
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.searchController.searchBar.text = ""
                $0.0.searchClearButton.isHidden = true
            })
            .disposed(by: rx.disposeBag)
    }
    
    private func bindIsLoading() {
        viewModel.isLoading
            .observe(on: MainScheduler.instance)
            .filter { $0 == true }
            .withUnretained(self)
            .subscribe(onNext: {
                if $0.0.tableView.refreshControl?.isRefreshing ?? false {
                    $0.0.tableView.refreshControl?.endRefreshing()
                }
            })
            .disposed(by: rx.disposeBag)
    }
    
}


// MARK: - Action
extension UserListViewController {
    
    @objc fileprivate func authorizeToggleButtonTapped() {
        
    }
    
}


// MARK: - UISearchBarDelegate
extension UserListViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchText = searchBar.text, !searchText.isEmpty else { return }
        viewModel.didSearch(string: searchText)
    }
    
}


// MARK: - UISearchControllerDelegate
extension UserListViewController: UISearchControllerDelegate {
    
}
