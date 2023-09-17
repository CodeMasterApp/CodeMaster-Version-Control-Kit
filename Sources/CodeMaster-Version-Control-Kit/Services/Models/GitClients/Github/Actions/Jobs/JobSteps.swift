//
//  File 3.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

public struct JobSteps: Codable {
    public let name: String
    public let status: String
    public let conclusion: String
    public let number: Int
    public let startedAt: String
    public let completedAt: String

    enum CodingKeys: String, CodingKey {
        case name
        case status
        case conclusion
        case number
        case startedAt = "started_at"
        case completedAt = "completed_at"
    }
}
