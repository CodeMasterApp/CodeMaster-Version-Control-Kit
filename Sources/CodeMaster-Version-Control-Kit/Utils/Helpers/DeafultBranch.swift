//
//  DefaultBranch.swift
//  CodeMaster
//
//  Copyright © 2023 CodeMaster Company. All rights reserved.
//  This source code is restricted for CodeMaster usage only
//  Note: Some parts of the code is from AuroraEditor - Please follow their LICENSE

import Foundation

public struct DeafultBranch {
    
    /// Default branch name that GithubDesktop uses when init a repo
    let defaultBranchInCM = "main"
    
    /// Name of the Git config var that Git uses when init a repo
    private let defaultBranchSettingName = "init.defaultBranch"
    
    /// Options for renaming Branches in CM. CM allows users renaming their branches
    public let suggestedDefaultBranchNames: [String] = ["main", "master", "dev"]
    
    /// Returns the chosen default branch
    public func getChosenDefaultBranch() throws -> String? {
        return try getGlobalConfigValue(name: defaultBranchSettingName)
    }
    
    /// Returns the configured default branch when creating new repositories
    public func getDefaultBranch() throws -> String {
        return defaultBranchInCM
    }
    
    /// Sets the configured default branch when creating new repositories.
    ///
    /// @param branchName - The default branch name to use.
    public func setDefaultBranch(branchName: String) throws -> String {
        return try setGlobalConfigValue(name: defaultBranchSettingName, value: branchName)
    }
}
