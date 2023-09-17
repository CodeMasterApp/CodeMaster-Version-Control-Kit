//
//  GitAuthor.swift
//  CodeMaster
//
//  Copyright © 2023 CodeMaster Company. All rights reserved.
//  This source code is restricted for CodeMaster usage only
//  Note: Some parts of the code is from AuroraEditor - Please follow their LICENSE

import Foundation

public class GitAuthor {
    /// CodeMaster needs the Users git name and email in order to connect to Git and GitHub
    var name: String
    var email: String
    
    public init(name: String?, email: String?) {
        self.name = name ?? "Unkown"
        self.email = email ?? "Unkown"
    }
    
    public func parse(nameAddr: String) -> GitAuthor? {
        let value = nameAddr.components(separatedBy: "/^(.*?)\\s+<(.*?)>//")
        return value.isEmpty ? nil : GitAuthor(name: value[1], email: value[2])
    }
    
    public func toString() -> String {
        return "\(self.name) \(self.email)"
    }
}
