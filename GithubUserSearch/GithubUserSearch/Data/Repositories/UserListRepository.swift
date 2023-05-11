//
//  UserListRepository.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import Foundation

import Moya
import RxMoya
import RxSwift

protocol UserListRepositoryProtocol {
    func searchUsers(query: String, page: Int) -> Observable<SearchUsersResponse?>
}

final class UserListRepository {
    let provider = MoyaProvider<MultiTarget>()
}

extension UserListRepository: UserListRepositoryProtocol {
    
    func searchUsers(query: String, page: Int) -> Observable<SearchUsersResponse?> {
        return provider.rx.request(MultiTarget(UserListTargetType(query: query, page: page)))
            .retry(3)
            .asObservable()
            .map { try JSONDecoder().decode(SearchUsersResponse.self, from: $0.data) }
            .catchAndReturn(nil)
    }
    
}
