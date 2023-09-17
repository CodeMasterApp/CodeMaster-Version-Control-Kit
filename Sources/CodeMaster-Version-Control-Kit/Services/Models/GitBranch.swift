//
//  File.swift
//  CodeMaster
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.

import Foundation

/// The number of commits a revision range is ahead/behind.
protocol IAheadBehind {
    var ahead: Int { get }
    var behind: Int { get }
}

public class AheadBehind: IAheadBehind {
    var ahead: Int
    var behind: Int

    init(ahead: Int, behind: Int) {
        self.ahead = ahead
        self.behind = behind
    }
}
