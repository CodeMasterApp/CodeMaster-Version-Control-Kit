//
//  File.swift
//  
//
//  Created by Nevio Hirani on 16.09.23.
//

import Foundation
import Combine

/// Shell Client
/// Run commands in shell
public class ShellClient {
    /// Generate a process and pipe to run commands
    /// - Parameter args: commands to run
    /// - Returns: command output
    func generateProcessAndPipe(_ args: [String]) -> (Process, Pipe) {
        /// a string argument is required to use this function. A Process and a Pipe (Unix) will be returned
        var arguments = ["-c"]
        arguments.append(contentsOf: args)
        let task = Process()
        let pipe = Pipe()
        task.standardOutput = pipe
        task.standardError = pipe
        task.standardInput = arguments
        task.executableURL = URL(fileURLWithPath: "/bin/zsh")
        return (task, pipe)
    }
}
