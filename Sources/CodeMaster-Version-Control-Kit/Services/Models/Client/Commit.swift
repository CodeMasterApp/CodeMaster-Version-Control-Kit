//
//  File.swift
//  
//
//  CodeMaster
//

import Foundation

public struct Commit {

    /// @param repository repository to execute merge in
    /// @param message commit message
    /// @param files files to commit
    /// @returns the commit SHA
    public func createCommit(directoryURL: URL,
                             message: String,
                             files: [GitFileItem],
                             amend: Bool = false) throws -> String {

        // Clear the staging area, our diffs reflect the difference between the
        // working directory and the last commit (if any) so our commits should
        // do the same thing.
        try Reset().unstageAll(directoryURL: directoryURL)

        var args = ["-F", "-"]

        if amend {
            args.append("--amend")
        }

        let result = try ShellClient.live().run(
            "cd \(directoryURL.relativePath.escapedWhiteSpaces());git commit \(args)"
        )

        return parseCommitSHA(result: result)
    }

    /// Creates a commit to finish an in-progress merge
    /// assumes that all conflicts have already been resolved
    ///
    /// @param repository repository to execute merge in
    /// @param files files to commit
    public func createMergeCommit() {}
}
