//
//  File.swift
//  CodeMaster
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.

import Foundation

/// Create a new tag on the given target commit.
///
/// @param name - The name of the new tag.
/// @param targetCommitSha  - The SHA of the commit where the new tag will live on.
public func createTag(directoryURL: URL,
                      name: String,
                      targetCommitSha: String) throws {
    let args = [
        "tag",
         "-a",
         "-m",
         "",
         targetCommitSha,
         name
    ]

    print("cd \(directoryURL.relativePath.escapedWhiteSpaces());git \(args.joined(separator: " "))")

    try ShellClient().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git \(args.joined(separator: " "))"
    )
}

/// Delete a Tag
///
/// @param name - The name of the tag to delete.
public func deleteTag(directoryURL: URL, name: String) throws {
    try ShellClient().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git tag -d \(name)"
    )
}

/// Gets all the local tags. Returns a Map with the tag name and the commit it points to.
public func getAllTags(directoryURL: URL) throws -> [String: String] {
    let tags = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git show-ref --tags -d"
    )

    // TODO: Find a way to convert string to dictionary
    return [:]
}

/// Fetches the tags that will get pushed to the remote repository.
///
/// @param remote - The remote to check for unpushed tags
/// @param branchName  - The branch that will be used on the push command
public func fetchTagsToPush(directoryURL: URL,
                            remote: GitRemote,
                            branchName: String) throws -> [String] {
    let args: [Any] = [
        gitNetworkArguments,
        "push",
        remote.name,
        branchName,
        "--follow-tags",
        "--dry-run",
        "--no-verify",
        "--porcelain"
    ]

    let result = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git \(args)"
    )

    let lines = result.split(separator: "\n").map { String($0) }
    var currentLine = 1
    var unpushedTags: [String] = []

    while currentLine < lines.count && lines[currentLine] != "Done" {
        let line = lines[currentLine]
        let parts = line

        if parts.substring(0) == "*" && parts.substring(2) == "[new tag]" {
            let tagName = parts.substring(1).split(separator: ":").map {
                String($0)
            }

            if !tagName.description.isEmpty {
                unpushedTags.append(tagName.description.replacingOccurrences(of: "/^refs\\/tags\\//", with: ""))
            }
        }
        currentLine += 1
    }

    return unpushedTags
}
