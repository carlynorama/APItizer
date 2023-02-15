//
//  ResponseService.swift
//  NetworkingExample
//
//  Created by Carlyn Maw on 10/29/22.
//

import Foundation

enum RequestServiceError:Error, CustomStringConvertible {
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

public protocol RequestService {
    var scheme:URIScheme { get }
    func serverHello(from url:URL) async throws -> String
    func fetchData(from url:URL) async throws -> Data
    func fetchData(for urlRequest:URLRequest) async throws -> Data
    func fetchRawString(from url:URL, encoding:String.Encoding) async throws -> String
    func fetchRawString(for urlRequest:URLRequest, encoding:String.Encoding) async throws -> String
    
    func postData(urlRequest:URLRequest, data:Data) async throws -> Data
    func postData(urlRequest:URLRequest) async throws -> Data

}


