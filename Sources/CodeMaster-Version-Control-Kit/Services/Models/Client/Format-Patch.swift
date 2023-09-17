//
//  File.swift
//  
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.

import Foundation

/// Generate a patch representing the changes associated with a range of commits
public func formatPatch(directoryURL: URL,
                        base: String,
                        head: String) throws -> String {
    let result = try ShellClient.live().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git format-path --unified=1 --minimal --stdout"
    )

    return result
}
