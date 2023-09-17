//
//  ShellClient.swift
//  CodeMaster
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
    
    /// Cancellable tasks
    var cancellables: [UUID: AnyCancellable] = [:]
    
    /// Run a command
    /// - Parameter args: command to run
    /// - Returns: command output
    @discardableResult
    public func run(_ args: String...) throws -> String {
        let (task, pipe) = generateProcessAndPipe(args)
        try task.run()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        return String(data: data, encoding: .utf8) ?? ""
    }
    
    /// Run a command with publisher
    /// - Parameter args: command to run
    /// - Returns: command output
    @discardableResult
    public func runLive(_ args: String...) -> AnyPublisher<String, Never> {
        let subject = PassthroughSubject<String, Never>()
        let (task, pipe) = generateProcessAndPipe(args)
        let outputHandler = pipe.fileHandleForReading
        // wait for the data to come in and then notify
        // the Notification with Name: `NSFileHandleDataAvailable`
        outputHandler.waitForDataInBackgroundAndNotify()
        let id = UUID()
        self.cancellables[id] = NotificationCenter
            .default
            .publisher(for: .NSFileHandleDataAvailable, object: outputHandler)
            .sink { _ in
                let data = outputHandler.availableData
                guard !data.isEmpty else {
                    // if no data is available anymore
                    // we should cancel this cancellable
                    // and mark the subject as finished
                    self.cancellables.removeValue(forKey: id)
                    subject.send(completion: .finished)
                    return
                }
                if let line = String(data: data, encoding: .utf8)?
                    .split(whereSeparator: \.isNewline) {
                    line
                        .map(String.init)
                        .forEach(subject.send(_:))
                }
                outputHandler.waitForDataInBackgroundAndNotify()
            }
        task.launch() // TODO: Change code
        return subject.eraseToAnyPublisher()
    }
    
    /// Shell client
    /// - Returns: description
    public static func live() -> ShellClient {
        return ShellClient()
    }
}
