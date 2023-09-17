//
//  File.swift
//  
//
//  CodeMaster
//

import Foundation

private var forkedRemotePrefix = "code-master-"

public func forkPullRequestRemoteName(remoteName: String) -> String {
    return "\(forkedRemotePrefix)\(remoteName)"
}

public protocol IRemote {
    var name: String { get }
    var url: String { get }
}

public class GitRemote: IRemote {
    public var name: String
    public var url: String

    init(name: String, url: String) {
        self.name = name
        self.url = url
    }
}
