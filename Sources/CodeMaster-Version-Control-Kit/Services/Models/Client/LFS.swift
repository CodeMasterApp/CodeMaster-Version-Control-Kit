//
//  File.swift
//  CodeMaster
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.


import Foundation

/// Install the global LFS filters.
public func installGlobalLFSFilters(force: Bool) throws {
    var args = ["lfs", "install", "--skip-repo"]

    if force {
        args.append("--force")
    }

    try ShellClient().run("git \(args)")
}

/// Install LFS hooks in the project
public func installLFSHooks(directoryURL: URL,
                            force: Bool) throws {
    var args = ["lfs", "install"]

    if force {
        args.append("--force")
    }

    try ShellClient().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git \(args)")
}

/// Is the repository configured to track any paths with LFS?
public func isUsingLFS(directoryURL: URL) throws -> Bool {
    let result = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git lfs track")

    return !result.isEmpty
}

/// Is the repository configured to track any paths with LFS?
public func isTrackedByLFS(directoryURL: URL,
                           path: String) throws -> Bool {
    let result = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git check-attr filter \(path)")

    // "git check-attr -a" will output every filter it can find in .gitattributes
    // and it looks like this:
    //
    // README.md: diff: lfs
    // README.md: merge: lfs
    // README.md: text: unset
    // README.md: filter: lfs
    //
    // To verify git-lfs this test will just focus on that last row, "filter",
    // and the value associated with it. If nothing is found in .gitattributes
    // the output will look like this
    //
    // README.md: filter: unspecified
    let lfsFilterRegex = "/: filter: lfs/"

    let match = result.contains(lfsFilterRegex)

    return match
}

/// Query a Git repository and filter the set of provided relative paths to see
/// which are not covered by the current Git LFS configuration.
///
/// @param filePaths List of relative paths in the repository
public func filesNotTrackedByLFS(directoryURL: URL,
                                 filePaths: [String]) throws -> [String] {
    var filesNotTrackedByGitLFS: [String] = []

    for filePath in filePaths {
        let isTracked = try isTrackedByLFS(directoryURL: directoryURL,
                                           path: filePath)

        if !isTracked {
            filesNotTrackedByGitLFS.append(filePath)
        }
    }

    return filesNotTrackedByGitLFS
}
