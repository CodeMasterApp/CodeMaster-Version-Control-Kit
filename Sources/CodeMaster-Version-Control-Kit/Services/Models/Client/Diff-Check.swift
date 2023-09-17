//
//  File.swift
//  
//
//  CodeMaster
//

import Foundation

/// Returns a list of files with conflict markers present
public func getFilesWithConflictMarkers(directoryURL: URL) throws -> [String: Int] {
    let args = ["diff", "--check"]
    let output = try ShellClient().run(
        "cd \(directoryURL.relativePath.escapedWhiteSpaces());git \(args)"
    )

    let outputString = output.utf8CString
    // TODO: Find a way to parse the data effeciently

    return [:]
}

/// Matches a line reporting a leftover conflict marker
/// and captures the name of the file
private let fileNameCapetureRe = "/(.+):\\d+: leftover conflict marker/gi"
