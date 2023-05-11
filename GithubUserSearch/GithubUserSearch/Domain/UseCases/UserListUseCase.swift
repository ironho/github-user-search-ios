//
//  UserListUseCase.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import Foundation

import RxSwift

protocol UserListUseCaseProtocol {
    func searchUsers(query: String, page: Int) -> Observable<SearchUsersResponse?>
}

final class UserListUseCase: UserListUseCaseProtocol {
    private let repository: UserListRepository
    
    init(repository: UserListRepository) {
        self.repository = repository
    }
    
    func searchUsers(query: String, page: Int) -> Observable<SearchUsersResponse?> {
        return repository.searchUsers(query: query, page: page)
    }
}
