//
//  FileManager.swift
//  CodeMaster
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

extension FileManager {
    public func directoryExistsAtPath(_ path: String) -> Bool {
        var isDirectory: ObjCBool = true
        let exists = self.fileExists(atPath: "file://\(path)", isDirectory: &isDirectory)
        return exists && isDirectory.boolValue
    }
}
