//
//  File 2.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

public struct Job: Codable {
    public let totalCount: Int
    public let jobs: [Jobs]

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case jobs
    }
}
