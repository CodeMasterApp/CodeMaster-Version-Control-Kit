//
//  File.swift
//  CodeMaster
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.


import Foundation

public enum MergeResult {
    /// The merge completed successfully
    case success
    /// The merge was a noop since the current branch
    /// was already up to date with the target branch.
    case alreadyUpToDate
    /// The merge failed, likely due to conflicts.
    case failed
}

/// Merge the named branch into the current branch.
public func merge(directoryURL: URL,
                  branch: String,
                  isSquash: Bool = false) throws -> MergeResult {
    var args = ["merge"]

    if isSquash {
        args.append("--squash")
    }

    args.append(branch)

    let result = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git \(args)"
    )

    if isSquash {
        let result = try ShellClient.live().run(
            "cd \(directoryURL.relativePath.escapedWhiteSpaces());git commit --no-edit"
        )
    }

    return result == noopMergeMessage ? MergeResult.alreadyUpToDate : MergeResult.success
}

private let noopMergeMessage = "Already up to date.\n"

/// Find the base commit between two commit-ish identifiers
public func getMergeBase(directoryURL: URL,
                         firstCommitish: String,
                         secondCommitish: String) throws -> String? {
    let process = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git merge-base \(firstCommitish) \(secondCommitish)"
    )

    return process.trimmingCharacters(in: .whitespaces)
}

/// Abort a mid-flight (conflicted) merge
public func abortMerge(directoryURL: URL) throws {
    _ = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git merge --abort"
    )
}

/// Check the `.git/MERGE_HEAD` file exists in a repository to confirm
/// that it is in a conflicted state.
public func isMergeHeadSet(directoryURL: URL) throws -> Bool {
    let path = try String(contentsOf: directoryURL) + ".git/MERGE_HEAD"
    return FileManager.default.fileExists(atPath: path)
}

/// Check the `.git/SQUASH_MSG` file exists in a repository
/// This would indicate we did a merge --squash and have not committed.. indicating
/// we have detected a conflict.
///
/// Note: If we abort the merge, this doesn't get cleared automatically which
/// could lead to this being erroneously available in a non merge --squashing scenario.
public func isSquashMsgSet(directoryURL: URL) throws -> Bool {
    let path = try String(contentsOf: directoryURL) + ".git/SQUASH_MSG"
    return FileManager.default.fileExists(atPath: path)
}
