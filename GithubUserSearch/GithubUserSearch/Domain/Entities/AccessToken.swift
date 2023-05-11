//
//  AccessToken.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/11.
//

import Foundation

struct AccessToken: Decodable {
    var access_token: String
    var scope: String
    var token_type: String
}
