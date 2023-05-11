//
//  UserListViewModel.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import Foundation

import NSObject_Rx
import RxCocoa
import RxSwift

protocol UserListViewModelInput {
    var authorizationViewModel: AuthorizationViewModel { get }
    var useCase: UserListUseCase { get }
    
    func didSearch(string: String)
    func loadPage()
    func loadNextPage()
}

protocol UserListViewModelOutput {
    var items: BehaviorRelay<[User]> { get }
    var isLoading: BehaviorRelay<Bool> { get }
    var isEmpty: BehaviorRelay<Bool> { get }
    var query: BehaviorRelay<String> { get }
    var isPagingEnded: BehaviorRelay<Bool> { get }
}

typealias UserListViewModelProtocol = UserListViewModelInput & UserListViewModelOutput

final class UserListViewModel: NSObject, UserListViewModelProtocol {
    
    var currentPage: Int = 0
    var nextPage: Int {
        currentPage = currentPage + 1
        return currentPage
    }
    
    private func resetPages() {
        currentPage = 0
        items.accept([])
        isPagingEnded.accept(false)
    }
    
    // MARK: - Input
    var authorizationViewModel: AuthorizationViewModel
    var useCase: UserListUseCase
    
    // MARK: - Output
    var items = BehaviorRelay<[User]>(value: [])
    var isLoading = BehaviorRelay<Bool>(value: false)
    var isEmpty = BehaviorRelay<Bool>(value: false)
    var query = BehaviorRelay<String>(value: "")
    var isPagingEnded = BehaviorRelay<Bool>(value: false)
    
    init(authorizationViewModel: AuthorizationViewModel, useCase: UserListUseCase) {
        self.authorizationViewModel = authorizationViewModel
        self.useCase = useCase
    }
}


// MARK: - Input
extension UserListViewModel {
    
    func didSearch(string: String) {
        resetPages()
        query.accept(string)
        
        loadPage()
    }
    
    func loadPage() {
        isLoading.accept(true)
        useCase.searchUsers(accessToken: authorizationViewModel.accessToken.value ?? "", query: query.value, page: nextPage)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, response) in
                owner.items.accept(owner.items.value + response.items)
                owner.isPagingEnded.accept(owner.items.value.count == response.total_count)
                owner.isEmpty.accept(response.total_count == 0)
                owner.isLoading.accept(false)
            }, onError: { [weak self] error in
                guard let `self` = self else { return }
                self.isPagingEnded.accept(true)
                self.isLoading.accept(false)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func loadNextPage() {
        loadPage()
    }
    
}
