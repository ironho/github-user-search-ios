//
//  UserListUseCase.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import Foundation

import RxSwift

protocol UserListUseCaseProtocol {
    func searchUsers(accessToken: String, query: String, page: Int) -> Observable<SearchUsersResponse>
}

final class UserListUseCase: UserListUseCaseProtocol {
    private let repository: UserListRepository
    
    init(repository: UserListRepository) {
        self.repository = repository
    }
    
    func searchUsers(accessToken: String, query: String, page: Int) -> Observable<SearchUsersResponse> {
        return repository.searchUsers(accessToken: accessToken, query: query, page: page)
    }
}
