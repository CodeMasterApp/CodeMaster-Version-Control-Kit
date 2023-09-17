//
//  File.swift
//  
//
//  CodeMaster
//

import Foundation

/// Check out the given branch.
///
/// @param repository - The repository in which the branch checkout should
///                take place
/// @param branch - The branch name that should be checked out
public func checkoutBranch(directoryURL: URL, branch: String) throws {
    try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git checkout \(branch)"
    )
}

/// Check out the paths at HEAD.
public func checkoutPaths(directoryURL: URL, paths: [String]) throws {
    try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git checkout HEAD --\(paths)"
    )
}

/// Check out either stage #2 (ours) or #3 (theirs) for a conflicted file.
public func checkoutConflictedFile() {}
