//
//  File.swift
//  CodeMasterEditorModules/Git
//
//  CodeMaster
//  Some parts of the code are from Aurora Editor - Please follow their LICENSE

import Foundation.NSDate

/// Model class to help map commit history log data
public struct CommitHistory: Equatable, Hashable, Identifiable {
    public var id = UUID()
    public let hash: String
    public let commitHash: String
    public let message: String
    public let author: String
    public let authorEmail: String
    public let commiter: String
    public let commiterEmail: String
    public let remoteURL: URL?
    public let date: Date
    public let isMerge: Bool?

    public init(hash: String,
                commitHash: String,
                message: String,
                author: String,
                authorEmail: String,
                commiter: String,
                commiterEmail: String,
                remoteURL: URL?,
                date: Date,
                isMerge: Bool?) {
        self.hash = hash
        self.commitHash = commitHash
        self.message = message
        self.author = author
        self.authorEmail = authorEmail
        self.commiter = commiter
        self.commiterEmail = commiterEmail
        self.remoteURL = remoteURL
        self.date = date
        self.isMerge = isMerge
    }

    public var commitBaseURL: URL? {
        if let remoteURL = remoteURL {
            if remoteURL.absoluteString.contains("github") {
                return parsedRemoteUrl(domain: "https://github.com", remote: remoteURL)
            }
            if remoteURL.absoluteString.contains("bitbucket") {
                return parsedRemoteUrl(domain: "https://bitbucket.org", remote: remoteURL)
            }
            if remoteURL.absoluteString.contains("gitlab") {
                return parsedRemoteUrl(domain: "https://gitlab.com", remote: remoteURL)
            }
            // TODO: Implement other git clients other than github, bitbucket here
        }
        return nil
    }

    private func parsedRemoteUrl(domain: String, remote: URL) -> URL {
        // There are 2 types of remotes - https and ssh. While https has URL in its name, ssh doesnt.
        // Following code takes remote name in format profileName/repoName and prepends according domain
        var formattedRemote = remote
        if formattedRemote.absoluteString.starts(with: "git@") {
            let parts = formattedRemote.absoluteString.components(separatedBy: ":")
            formattedRemote = URL.init(fileURLWithPath: "\(domain)/\(parts[parts.count - 1])")
        }

        return formattedRemote.deletingPathExtension().appendingPathComponent("commit")
    }

    public var remoteString: String {
        if let remoteURL = remoteURL {
            if remoteURL.absoluteString.contains("github") {
                return "GitHub"
            }
            if remoteURL.absoluteString.contains("bitbucket") {
                return "BitBucket"
            }
            if remoteURL.absoluteString.contains("gitlab") {
                return "GitLab"
            }
        }
        return "Remote"
    }
}
