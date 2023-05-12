//
//  AccessTokenTargetType.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/11.
//

import Foundation

import Moya

/**
 https://docs.github.com/en/apps/oauth-apps/building-oauth-apps/authorizing-oauth-apps#2-users-are-redirected-back-to-your-site-by-github
 */
struct AccessTokenTargetType: TargetType {
    
    var baseURL = URL.githubBaseURL
    var path: String { "login/oauth/access_token" }
    var method: Moya.Method = .post
    var sampleData = """
    {
      "access_token":"gho_16C7e42F292c6912E7710c838347Ae178B4a",
      "scope":"repo,gist",
      "token_type":"bearer"
    }
    """.data(using: .utf8)!
    var task: Task { .requestJSONEncodable(parameters) }
    var headers: [String: String]? = ["Accept": "application/json"]
    
    var parameters: [String: String] = [: ]
    
    init(code: String) {
        self.parameters = [
            "client_id": Constants.githubClientID,
            "client_secret": Constants.githubSecret,
            "code": code
        ]
    }
    
}
