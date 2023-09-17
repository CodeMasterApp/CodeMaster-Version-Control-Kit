//
//  File 2.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation
import SwiftUI

public struct Workflow: Codable, Hashable, Identifiable, Comparable {
    public static func < (lhs: Workflow, rhs: Workflow) -> Bool {
        return lhs.name < rhs.name
    }
    
    public let id: Int
    public let nodeId: String
    public let name: String
    public let path: String
    public let state: String
    public let createdAt: String
    public let updatedAt: String
    public let url: String
    public let htmlURL: String
    
    enum CodingKeys: String, CodingKey {
        case id
        case nodeId = "node_id"
        case name
        case path
        case state
        case createdAt = "created_at"
        case updatedAt = "updated_at"
        case url
        case htmlURL = "html_url"
    }
}
