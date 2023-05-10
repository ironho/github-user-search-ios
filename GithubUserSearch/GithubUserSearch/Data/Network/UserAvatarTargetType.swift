//
//  UserAvatarTargetType.swift
//  GithubUserSearch
//
//  Created by cheolho on 2023/05/10.
//

import Foundation

import Moya

struct UserAvatarTargetType: TargetType {
    
    var baseURL: URL { URL(string: components?.host ?? "")! }
    var path: String { components?.path ?? "" }
    var method: Moya.Method = .get
    var sampleData = """
              https://secure.gravatar.com/avatar/25c7c18223fb42a4c6ae1c8db6f50f9b?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png
    """.data(using: .utf8)!
    var task: Task {
        let documentsDirectory = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask)
        let devFolderUrl = documentsDirectory[0].appendingPathComponent("UserAvatar")
        let fileUrl = devFolderUrl.appendingPathComponent(((components?.path ?? "") as NSString).lastPathComponent)
        var downloadDest: DownloadDestination {
            return { _, _ in return (fileUrl, [.removePreviousFile, .createIntermediateDirectories]) }
        }
        return .downloadDestination(downloadDest)
    }
    var headers: [String: String]?

    var components: URLComponents?
    
    init(url: URL) {
        self.components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    }
    
}
