//
//  File.swift
//  CodeMaster
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.

import Foundation

/// Remove all files from the index
public func unstageAllFiles(directoryURL: URL) {
    do {
        try ShellClient().run(
            // these flags are important:
            // --cached - to only remove files from the index
            // -r - to recursively remove files, in case files are in folders
            // -f - to ignore differences between working directory and index
            //          which will block this
            "cd \(directoryURL.relativePath.escapedWhiteSpaces());git rm -cached -r -f .")
    } catch {
        print("Failed to unstage all files")
    }
}

/// Remove conflicted file from  working tree and index
public func removeConflictedFile(directoryURL: URL,
                                 file: GitFileItem) throws {
    try ShellClient().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git rm --\(file.url)")
}
