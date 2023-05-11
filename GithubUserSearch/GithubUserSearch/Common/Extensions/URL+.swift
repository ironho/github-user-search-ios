//
//  URL+.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/11.
//

import Foundation

extension URL {
    
    static let signInURL = URL(
        string: "https://github.com/login/oauth/authorize",
        query: [
            "client_id": Constants.githubClientID,
            "scope": "user"
        ]
    )!
    
    static let accessTokenURL = URL(string: "https://github.com/login/oauth/access_token")!
    static let githubApiBaseURL = URL(string: "https://api.github.com")!
    
}


// MARK: - init
extension URL {
    
    init?(string: String, query: [String: String?]) {
        guard var urlComponents = URLComponents(string: string) else {
            return nil
        }
        urlComponents.queryItems = query.map {
            URLQueryItem(name: $0.key, value: $0.value)
        }
        guard let url = urlComponents.url else {
            return nil
        }
        self.init(string: url.absoluteString)
    }
    
}
