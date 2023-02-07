//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/5/23.
//

import Foundation

public extension APIServer {
    func serverHello(from url:URL) async throws -> String {
        try await scheme.requestService.serverHello(from: url)
    }
    func fetchRawString(from:URL, encoding:String.Encoding) async throws -> String {
        try await scheme.requestService.fetchRawString(from: from, encoding: encoding)
    }
//    func checkForValidResponse(_ response: URLResponse) async -> (isValid:Bool, mimeType:String?) {
//        await scheme.requestService.checkForValidResponse(response)
//    }
    func fetch(from url:URL) async throws -> Data {
        try await scheme.requestService.fetch(from: url)
    }
    
}

