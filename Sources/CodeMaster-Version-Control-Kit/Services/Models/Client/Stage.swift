//
//  File.swift
//  CodeMaster
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.


import Foundation

/// Stages a file with the given manual resolution method.
/// Useful for resolving binary conflicts at commit-time.
public func stageManualConflictResolution(directoryURL: URL,
                                          file: GitFileItem,
                                          manualResoultion: ManualConflictResolution) throws {
    let status = file

    // TODO: Check conflicted state and conflicted with markers
}
