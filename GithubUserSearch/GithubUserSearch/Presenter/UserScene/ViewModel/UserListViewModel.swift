//
//  UserListViewModel.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import Foundation

import RxCocoa
import RxSwift

protocol UserListViewModelInput {
    func didSearch(string: String)
    func loadPage()
    func loadNextPage()
    func didSelectItem(model: User)
}

protocol UserListViewModelOutput {
    var items: BehaviorRelay<[User]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isEmpty: BehaviorRelay<Bool> { get }
    var query: BehaviorRelay<String> { get }
    var isPagingEnded: BehaviorRelay<Bool> { get }
}

typealias UserListViewModelProtocol = UserListViewModelInput & UserListViewModelOutput

final class UserListViewModel: UserListViewModelProtocol {
    
    // MARK: - Output
    var items = BehaviorRelay<[User]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isEmpty = BehaviorRelay<Bool>(value: false)
    var query = BehaviorRelay<String>(value: "")
    var isPagingEnded = BehaviorRelay<Bool>(value: false)
    
}


// MARK: - Input
extension UserListViewModel {
    
    func didSearch(string: String) {
        
    }
    
    func loadPage() {
        
    }
    
    func loadNextPage() {
        
    }
    
    func didSelectItem(model: User) {
        
    }
    
}
