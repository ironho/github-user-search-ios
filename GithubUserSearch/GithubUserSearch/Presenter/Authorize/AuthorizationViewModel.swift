//
//  AuthorizationViewModel.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/11.
//

import Foundation

import RxSwift
import RxCocoa

protocol AuthorizationViewModelInput {
    var authorizationUseCase: AuthorizationUseCase { get }
    
    func clearToken()
    func requestAccessToken(_code: String)
    func hasAuthorization() -> Bool
}

protocol AuthorizationViewModelOutput {
    var code: BehaviorRelay<String?> { get }
    var accessToken: BehaviorRelay<String?> { get }
}

typealias AuthorizationViewModelProtocol = AuthorizationViewModelInput & AuthorizationViewModelOutput

class AuthorizationViewModel: NSObject, AuthorizationViewModelProtocol {
    
    // MARK: - Input
    var authorizationUseCase: AuthorizationUseCase

    // MARK: - Output
    var code = BehaviorRelay<String?>(value: nil)
    var accessToken = BehaviorRelay<String?>(value: nil)
    
    init(authorizationUseCase: AuthorizationUseCase) {
        self.authorizationUseCase = authorizationUseCase
        super.init()
        
        bindCode()
    }
}


// MARK: - Input
extension AuthorizationViewModel {
    
    func clearToken() {
        accessToken.accept(nil)
    }
    
    func requestAccessToken(_code: String) {
        authorizationUseCase.requestAccessToken(code: _code)
            .observe(on: MainScheduler.instance)
            .withUnretained(self)
            .subscribe(onNext: { (owner, response) in
                owner.accessToken.accept(response.access_token)
            })
            .disposed(by: rx.disposeBag)
    }
    
    func hasAuthorization() -> Bool {
        return accessToken.value != nil
    }
    
}


// MARK: - Bind
extension AuthorizationViewModel {
    
    func bindCode() {
        code
            .filter { $0 != nil }
            .map { $0! }
            .withUnretained(self)
            .subscribe(onNext: {
                $0.0.requestAccessToken(_code: $0.1)
            })
            .disposed(by: rx.disposeBag)
    }
    
}
