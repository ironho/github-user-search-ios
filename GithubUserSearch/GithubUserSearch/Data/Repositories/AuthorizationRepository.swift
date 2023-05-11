//
//  AuthorizationRepository.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/11.
//

import Foundation

import Moya
import RxSwift

protocol AuthorizationRepositoryProtocol {
    func requestAccessToken(code: String) async throws -> Observable<AccessToken?>
}

final class AuthorizationRepository {
    let provider = MoyaProvider<MultiTarget>()
}

extension AuthorizationRepository: AuthorizationRepositoryProtocol {
    
    func requestAccessToken(code: String) -> Observable<AccessToken?> {
        return provider.rx.request(MultiTarget(AccessTokenTargetType(code: code)))
            .retry(3)
            .asObservable()
            .map { try JSONDecoder().decode(AccessToken.self, from: $0.data) }
            .catchAndReturn(nil)
    }
    
}
