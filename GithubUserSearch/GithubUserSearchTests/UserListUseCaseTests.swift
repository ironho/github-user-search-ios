//
//  UserListUseCaseTests.swift
//  GithubUserSearchTests
//
//  Created by cheolho on 2023/05/09.
//

import XCTest
@testable import GithubUserSearch

import RxBlocking
import RxSwift

final class UserListUseCaseTests: XCTestCase {
    var repository: UserListRepository!
    var useCase: UserListUseCase!

    override func setUpWithError() throws {
        repository = UserListRepository()
        useCase = UserListUseCase(repository: repository)
    }

    override func tearDownWithError() throws {
        repository = nil
        useCase = nil
    }

    func testSearchMe() {
        do {
            let response = try useCase.searchUsers(accessToken: "", query: "ironho", page: 1)
                .observe(on: MainScheduler.instance)
                .toBlocking(timeout: 10)
                .first()
            XCTAssertTrue(response??.items.count ?? 0 > 0)
            XCTAssertEqual(response??.items.first?.login, "ironho")
        } catch {
            XCTFail(error.localizedDescription)
        }
    }

}
