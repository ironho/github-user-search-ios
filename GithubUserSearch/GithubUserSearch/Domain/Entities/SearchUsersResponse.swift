//
//  SearchUsersResponse.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/09.
//

import Foundation

struct SearchUsersResponse: Decodable {
    
    var total_count: Int
    var incomplete_results: Bool
    var items: [User]
    
}
