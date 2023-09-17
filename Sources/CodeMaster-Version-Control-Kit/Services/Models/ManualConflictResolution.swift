//
//  File.swift
//  
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.

import Foundation

// NOTE: These strings have semantic value, they're passed directly
// as `--ours` and `--theirs` to git checkout. Please be careful
// when modifying this type.
public enum ManualConflictResolution {
    case theirs
    case ours
}
