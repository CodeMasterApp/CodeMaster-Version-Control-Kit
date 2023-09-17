//
//  File.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

public struct Workflows: Codable {
    public let totalCount: Int
    public let workflows: [Workflow]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case workflows
    }
}
