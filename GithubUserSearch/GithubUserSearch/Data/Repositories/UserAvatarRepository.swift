//
//  UserAvatarRepository.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/10.
//

import Foundation

import Moya
import RxMoya
import RxSwift

protocol UserAvatarRepositoryProtocol {
    func userAvatar(url: URL) async throws -> Observable<Data>
}


final class UserAvatarRepository {
    let provider = MoyaProvider<MultiTarget>()
}

extension UserAvatarRepository: UserAvatarRepositoryProtocol {
    
    func userAvatar(url: URL) -> Observable<Data> {
        return provider.rx.request(MultiTarget(UserAvatarTargetType(url: url)))
            .retry(3)
            .asObservable()
            .map { $0.data }
    }
    
}
