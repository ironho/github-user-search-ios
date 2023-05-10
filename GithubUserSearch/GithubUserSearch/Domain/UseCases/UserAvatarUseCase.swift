//
//  UserAvatarUseCase.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/10.
//

import Foundation

import RxSwift

protocol UserAvatarUseCaseProtocol {
    func userAvatar(url: URL) -> Observable<Data>
}

final class UserAvatarUseCase: UserAvatarUseCaseProtocol {
    private let repository: UserAvatarRepository
    
    init(repository: UserAvatarRepository) {
        self.repository = repository
    }
    
    func userAvatar(url: URL) -> Observable<Data> {
        return repository.userAvatar(url: url)
    }
}
