//
//  File.swift
//  
//
//  CodeMaster
//

import Foundation

/// Init a new git repository in the given path.
public func initGitRepository(directoryURL: URL) throws {
    try ShellClient().run(
        // swiftlint:disable:next line_length
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git -c init.defaultBranch=\(DefaultBranch().getDefaultBranch()) init"
    )
}
