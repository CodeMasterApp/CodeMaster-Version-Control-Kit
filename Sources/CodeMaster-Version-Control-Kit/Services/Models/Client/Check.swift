//
//  File.swift
//  
//
//  CodeMaster
//

import Foundation

public func checkIfProjectIsRepo(workspaceURL: URL) -> Bool {
    do {
        let type = try getRepositoryType(path: workspaceURL.path)

        if type == .unsafe {
            // If the path is considered unsafe by Git we won't be able to
            // verify that it's a repository (or worktree). So we'll fall back to this
            // naive approximation.
            print(type)
            return FileManager().directoryExistsAtPath("\(workspaceURL)/.git")
        }

        return type != .missing
    } catch {
        print("We couldn't verify if the current project is a git repo!")
        return false
    }
}
