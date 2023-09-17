//
//  File.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation

public struct WorkflowRuns: Codable {
    public let totalCount: Int
    public let workflowRuns: [WorkflowRun]?

    enum CodingKeys: String, CodingKey {
        case totalCount = "total_count"
        case workflowRuns = "workflow_runs"
    }
}
