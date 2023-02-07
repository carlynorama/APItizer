//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation

public struct HTTPRequestService:RequestService {
    internal var session:URLSession
    
    public init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    //MARK: - Level One Fetch Requests (Hello World)
    
    public func serverHello(from url:URL) async throws -> String {
        let (_, response) = try await session.data(from: url)  //TODO: catch the error here
        //print(response)
        let (isValid, mimeType) = await checkForValidResponse(response)
        return "The url returns a \(isValid ? "valid":"invalid") HTTP response\(isValid ? " of type \(mimeType ?? "unknown")":".")"
    }
    
    public func fetchRawString(from:URL, encoding:String.Encoding = .utf8) async throws -> String {
        let (data, _) = try await session.data(from: from)
        guard let string = String(data: data, encoding: encoding) else {
            throw RequestServiceError("Got data, couldn't make a string with \(encoding)")
        }
        return string
    }
    
    //MARK: - Generic HTTP Handling
    public func fetch(from url:URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)  //TODO: catch the error here
       //print(response)
        guard await checkForValidResponse(response).isValid else {
            throw RequestServiceError("Not valid HTTP")
        }
        
//        if debugLog {
//            let string = String(decoding: data, as: UTF8.self)
//            print(string)
//        }
        return data
    }
    
    public func checkForValidResponse(_ response:URLResponse) async -> (isValid:Bool, mimeType:String?) {
        guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response)
                    return (false, nil)
        }

        return (true, httpResponse.mimeType)
    }
    
    func handleServerError(_ response:URLResponse) {
        print(response)
    }
    
}
