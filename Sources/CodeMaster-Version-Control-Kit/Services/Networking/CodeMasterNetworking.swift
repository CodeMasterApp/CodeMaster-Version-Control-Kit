//
//  File.swift
//  
//
//  Created by Nevio Hirani on 17.09.23.
//

import Foundation
import Combine
import SwiftUI

class CodeMasterNetworking {
    static let shared = CodeMasterNetworking()
    
    /// All the cookies
    static var cookies: [HTTPCookie]? = []

    /// the full networkRequestResponse
    static var fullResponse: String? = ""

    /// The dispatch group
    static let group: DispatchGroup = .init()
    
    struct NetworkingError: Error {
            let message: String

            init(message: String) {
                self.message = message
            }

            public var localizedDescription: String {
                return message
            }
        }

        private func createRequest(url: URL, useGitAuth: Bool) -> URLRequest {
            /// Create a URL Request
            var request = URLRequest(url: url)

            /// Header values: we just add it automatically since all requests use the same headers
            request.addValue(
                "application/vnd.github+json",
                forHTTPHeaderField: "Accept"
            )

            // Create an extension that adds the Auth Header
    //        request.setValue(
    //        "Bearer \(keychain.get("github_\(username!)")!)",
    //        forHTTPHeaderField: "Authorization")

            return request
        }

        private func exec(
            with request: URLRequest,
            completionHandler: @escaping (Result<Data, Error>) -> Void,
            file: String = #file,
            line: Int = #line,
            function: String = #function) {
                /// Create a  URLSession
                var session: URLSession? = URLSession.shared

                if let cookieData = CodeMasterNetworking.cookies {
                    session?.configuration.httpCookieStorage?.setCookies(
                        cookieData,
                        for: request.url,
                        mainDocumentURL: nil
                    )
                }

                // Start our datatask
                session?.dataTask(with: request) { [self] (sitedata, response, taskError) in
                    /// Check if we got any useable site data
                    guard let sitedata = sitedata else {
                        completionHandler(.failure(taskError ?? NetworkingError(message: "Unknown error")))
                        return
                    }
                    
                // Save our cookies
                CodeMasterNetworking.cookies = session?.configuration.httpCookieStorage?.cookies
                CodeMasterNetworking.fullResponse = String.init(data: sitedata, encoding: .utf8)

                if let httpResponse = response as? HTTPURLResponse {
                    self.networkLog(
                        request: request, session: session, response: response, data: sitedata,
                        file: file, line: line, function: function
                    )
                    
                switch httpResponse.statusCode {
                    case 200, 201:
                        completionHandler(
                            .success(sitedata)
                        )
                        return print("[\(function)] OK")
                    default:
                        return completionHandler(
                            .failure(
                                NetworkingError(message: String(data: sitedata, encoding: .utf8)!)
                            )
                        )
                    }
                }
            }.resume()

        // Release the session from memory
        session = nil
    }

    /// Creates a network request that retrieves the contents of a URL \
        /// based on the specified URL request object, and calls a handler upon completion.
        ///
        /// - Parameters:
        ///   - url: A value that identifies the location of a resource, \
        ///   such as an item on a remote server or the path to a local file.
        ///   - method: The HTTP request method.
        ///   - parameters: POST values (if any)
        ///   - completionHandler: This completion handler takes the following parameters:
        ///   `Result<Data, Error>`
        ///     - `Data`: The data returned by the server.
        ///     - `Errror`: An error object that indicates why the request failed, or nil if the request was successful.
        public func request(
            baseURL: String,
            path: String,
            useAuth: Bool = true,
            method: HTTPMethod,
            parameters: [String: Any]?,
            completionHandler: @escaping (Result<Data, Error>) -> Void,
            file: String = #file, line: Int = #line, function: String = #function
        ) {
            /// Check if the URL is valid
            guard let siteURL = URL(string: baseURL + path) else {
                completionHandler(
                    .failure(
                        NetworkingError(message: "Error: Request endpoint doesn't appear to be an URL")
                    )
                )
                return
            }

            /// Create a URL Request
            var request = createRequest(url: siteURL, useGitAuth: useAuth)
            request.httpMethod = method.rawValue

            if method == .POST || method == .PUT {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters ?? "")
            }

            exec(with: request, completionHandler: { result in
                completionHandler(result)
            }, file: file, line: line, function: function)
        }

        public func request(
            path: String,
            method: HTTPMethod,
            useAuth: Bool = true,
            parameters: [[String: Any]],
            completionHandler: @escaping (Result<Data, Error>) -> Void,
            file: String = #file, line: Int = #line, function: String = #function
        ) {
            /// Check if the URL is valid
            guard let siteURL = URL(string: GithubNetworkingConstants.baseURL + path) else {
                completionHandler(
                    .failure(
                        NetworkingError(message: "Error: Request endpoint doesn't appear to be an URL")
                    )
                )
                return
            }

            /// Create a URL Request
            var request = createRequest(url: siteURL, useGitAuth: useAuth)
            request.httpMethod = method.rawValue

            if method == .POST || method == .PUT {
                request.httpBody = try? JSONSerialization.data(withJSONObject: parameters)
            }

            exec(with: request, completionHandler: { result in
                completionHandler(result)
            }, file: file, line: line, function: function)
        }

        /// Creates a network request that retrieves the contents of a URL \
        /// based on the specified URL request object, and calls a handler upon completion.
        ///
        /// - Parameters:
        ///   - url: A value that identifies the location of a resource, \
        ///   such as an item on a remote server or the path to a local file.
        ///   - method: The HTTP request method.
        ///   - useAuthToken: Use auth token?
        ///   - parameters: Codable post value
        ///   - completionHandler: This completion handler takes the following parameters:
        ///   `Result<Data, Error>`
        ///     - `Data`: The data returned by the server.
        ///     - `Errror`: An error object that indicates why the request failed, or nil if the request was successful.
        public func request<T: Encodable>(
            path: String,
            method: HTTPMethod,
            useAuth: Bool = true,
            parameters: T,
            completionHandler: @escaping (Result<Data, Error>) -> Void,
            file: String = #file, line: Int = #line, function: String = #function
        ) {
            /// Check if the URL is valid
            guard let siteURL = URL(string: GithubNetworkingConstants.baseURL + path) else {
                completionHandler(
                    .failure(
                        NetworkingError(message: "Error: Request endpoint doesn't appear to be an URL")
                    )
                )
                return
            }

            /// Create a URL Request
            var request = createRequest(url: siteURL, useGitAuth: useAuth)
            request.httpMethod = method.rawValue

            if method == .POST || method == .PUT {
                request.httpBody = try? JSONEncoder().encode(parameters)
            }

            exec(with: request, completionHandler: { result in
                completionHandler(result)
            }, file: file, line: line, function: function)
        }

        /// Return the full networkRequestResponse
        /// - Returns: the full networkRequestResponse
        public func networkRequestResponse() -> String? {
            return CodeMasterNetworking.fullResponse
        }

        func networkLog(request: URLRequest?,
                        session: URLSession?,
                        response: URLResponse?,
                        data: Data?,
                        file: String = #file,
                        line: Int = #line,
                        function: String = #function) {
            if (response as? HTTPURLResponse)?.statusCode == 200 {
                return
            }

    #if DEBUG
            print("Network debug start")
            if let request = request {
                self.networkLogRequest(request: request)
            }

            if let response = response as? HTTPURLResponse {
                self.networkLogResponse(response: response)
            }

            if let data = data {
                self.networkLogData(data: data)
            }

            print("End of network debug\n")
    #endif
        }

        private func networkLogRequest(request: URLRequest) {
            print("URLRequest:")
            print("  \(request.httpMethod!) \(request.url!)")
            print("\n  Headers:")
            for (header, cont) in request.allHTTPHeaderFields! {
                print("    \(header): \(cont)")
            }
            print("\n  Body:")
            if let httpBody = request.httpBody,
               let body = String(data: httpBody, encoding: .utf8) {
                print("    \(body)")
            }
            print("\n")
        }

        private func networkLogResponse(response: HTTPURLResponse) {
            print("HTTPURLResponse:")
            print("  HTTP \(response.statusCode)")
            for (header, cont) in response.allHeaderFields {
                print("    \(header): \(cont)")
            }
        }

        private func networkLogData(data: Data) {
            if let stringData = String(data: data, encoding: .utf8) {
                print("\n  Body:")
                for line in stringData.split(separator: "\n") {
                    print("    \(line)")
                }

                do {
                    print("\n  Decoded JSON:")
                    if let dictionary = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
                        for (key, value) in dictionary {
                            print("    \(key): \"\(value)\"")
                        }
                    }
                } catch {
                    print(error.localizedDescription)
                }
            }
        }

        private func handleNetworkError(data: Data) -> String {
            if let errorData = String(data: data, encoding: .utf8) {
                for line in errorData.split(separator: "\n") {
                    return String(line)
                }
            }
            return ""
        }
}
