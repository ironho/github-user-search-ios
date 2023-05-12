//
//  AuthorizationUseCase.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/11.
//

import Foundation

import RxSwift

protocol AuthorizationUseCaseProtocol {
    func requestAccessToken(code: String) -> Observable<AccessToken>
}

final class AuthorizationUseCase: AuthorizationUseCaseProtocol {
    private let repository: AuthorizationRepository
    
    init(repository: AuthorizationRepository) {
        self.repository = repository
    }
    
    func requestAccessToken(code: String) -> Observable<AccessToken> {
        return repository.requestAccessToken(code: code)
    }
}
