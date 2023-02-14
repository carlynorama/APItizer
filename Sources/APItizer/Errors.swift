//
//  Errors.swift
//  
//
//  Created by Carlyn Maw on 10/30/22 as part of ActivityPubExplorer
//


import Foundation


enum APItizerError: Error, CustomStringConvertible {
    case message(String)
 
    public var description: String {
        switch self {
        case let .message(message): return message
        }
    }
    init(_ message: String) {
        self = .message(message)
    }
    
}

enum HTTPRequestServiceError: Error, CustomStringConvertible {
    case message(String)
    public var description: String {
        switch self {
        case let .message(message): return message
        }
    }
    init(_ message: String) {
        self = .message(message)
    }
}

enum AuthorizableError: Error, CustomStringConvertible {
    case message(String)
    case noTokenEnv
    case noTokenKeychain
    public var description: String {
        switch self {
        case let .message(message): return message
        case .noTokenEnv:
            return "No token was found in the environment."
        case .noTokenKeychain:
            return "No token was found in the Keychain"
        }
    }
    init(_ message: String) {
        self = .message(message)
    }
}
