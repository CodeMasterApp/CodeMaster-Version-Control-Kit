//
//  File.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

/// A enum class that has strings that can be used to check what
/// type of error we got back from the lookout api.
enum HTTPErrors: String, Error {
    case notVerified = "User is not verified"
}
