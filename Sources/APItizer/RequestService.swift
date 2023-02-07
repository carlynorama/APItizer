//
//  ResponseService.swift
//  NetworkingExample
//
//  Created by Carlyn Maw on 10/29/22.
//

import Foundation

public enum RequestServiceError:Error, CustomStringConvertible {
    case message(String)
    public var description: String {
        switch self {
        case let .message(message): return message
        }
    }
    fileprivate init(_ message: String) {
        self = .message(message)
    }
}

public protocol RequestService {
    func serverHello(from url:URL) async throws -> String
    func fetchRawString(from:URL, encoding:String.Encoding) async throws -> String
//    func checkForValidResponse(_ response: URLResponse) async -> (isValid:Bool, mimeType:String?)
    func fetch(from url:URL) async throws -> Data
}
