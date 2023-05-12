//
//  URL+.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/11.
//

import Foundation

extension URL {
    
    static let signInURL = URL(string: "login/oauth/authorize", relativeTo: githubBaseURL)!
        .appending([
            "client_id": Constants.githubClientID,
            "scope": "user"
        ])
    
    static let accessTokenURL = URL(string: "login/oauth/access_token", relativeTo: githubBaseURL)
    static let githubBaseURL = URL(string: "https://github.com")!
    static let githubApiBaseURL = URL(string: "https://api.github.com")!
    
}


// MARK: - func
extension URL {
    
    func appending(_ parameters: [String: String?]) -> URL {
        guard var urlComponents = URLComponents(string: absoluteString) else { return absoluteURL }
        var queryItems = urlComponents.queryItems ?? []
        for parameter in parameters {
            queryItems.append(URLQueryItem(name: parameter.key, value: parameter.value))
        }
        urlComponents.queryItems = queryItems
        return urlComponents.url!
    }
    
}
