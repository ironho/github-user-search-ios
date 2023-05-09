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
    func searchUsers(query: String, page: Int) async throws -> Observable<SearchUsersResponse>
}


final class UserListRepository {
    
}

extension UserListRepository: UserListRepositoryProtocol {
    
    func searchUsers(query: String, page: Int) -> Observable<SearchUsersResponse> {
        let provider = MoyaProvider<MultiTarget>()
        return provider.rx.request(MultiTarget(UserListTargetType(query: query, page: page)))
            .retry(3)
            .asObservable()
            .map { try JSONDecoder().decode(SearchUsersResponse.self, from: $0.data) }
    }
    
}
