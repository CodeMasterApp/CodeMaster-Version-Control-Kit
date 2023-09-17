//
//  File.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

public protocol GitFileItem: Codable {

    var gitStatus: GitType? { get set }

    /// Returns the URL of the ``FileSystemClient/FileSystemClient/FileItem``
    var url: URL { get set }
}
