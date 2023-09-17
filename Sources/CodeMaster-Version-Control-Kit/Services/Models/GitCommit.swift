//
//  File.swift
//  
//
//  CodeMaster
//  Copyright © 2022 Aurora Company. All rights reserved.

import Foundation

/// Grouping of information required to create a commit
public protocol ICommitContext {
    /// The summary of the commit message (required)
    var summary: String? { get }
    /// Additional details for the commit message (optional)
    var description: String? { get }
    /// Whether or not it should amend the last commit (optional, default: false)
    var amend: Bool? { get }
    /// An optional array of commit trailers (for example Co-Authored-By trailers)
    /// which will be appended to the commit message in accordance with the Git trailer configuration.
    var trailers: [Trailer]? { get }
}

public class CommitContext: ICommitContext {
    public var summary: String?
    public var description: String?
    public var amend: Bool?
    public var trailers: [Trailer]?

    public init(summary: String?,
                description: String?,
                amend: Bool?,
                trailers: [Trailer]?) {
        self.summary = summary
        self.description = description
        self.amend = amend
        self.trailers = trailers
    }
}

/// Extract any Co-Authored-By trailers from an array of arbitrary trailers.
public func extractCoAuthors(trailers: [Trailer]) -> [GitAuthor] {
    var coAuthors: [GitAuthor] = []

    for trailer in trailers where isCoAuthoredByTrailer(trailer: trailer) {
        let author = GitAuthor(name: nil, email: nil).parse(nameAddr: trailer.value)
        if author != nil {
            coAuthors.append(author!)
        }
    }

    return coAuthors
}

/// A minimal shape of data to represent a commit, for situations where the
/// application does not require the full commit metadata.
///
/// Equivalent to the output where Git command support the
/// `--oneline --no-abbrev-commit` arguments to format a commit.
public class CommitOneLine {
    var sha: String
    var summary: String

    public init(sha: String, summary: String) {
        self.sha = sha
        self.summary = summary
    }
}

/// A git commit.
public class GitCommit {
    /// A list of co-authors parsed from the commit message
    /// trailers.
    var coAuthors: [GitAuthor]?
    /// The commit body after removing coauthors
    var bodyNoCoAuthors: String?
    /// A value indicating whether the author and the committer
    /// are the same person.
    var authoredByCommitter: Bool
    /// Whether or not the commit is a merge commit (i.e. has at least 2 parents)
    var isMergeCommit: Bool

    public init(sha: String,
                shortSha: String,
                summary: String,
                body: String,
                author: String,
                commiter: String,
                parentShas: [String],
                trailers: [Trailer],
                tags: [String]) {
        self.coAuthors = extractCoAuthors(trailers: trailers)
        self.authoredByCommitter = false
        self.bodyNoCoAuthors = ""
        self.isMergeCommit = parentShas.count > 1
    }
}
