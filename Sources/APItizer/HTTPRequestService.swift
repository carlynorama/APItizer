//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation

public struct HTTPRequestService:RequestService {
    public enum Method: String {
        case delete = "DELETE", get = "GET", head = "HEAD", patch = "PATCH", post = "POST", put = "PUT"
    }
    
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
    
    func fetch(urlRequest:URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest)
        guard await checkForValidResponse(response).isValid else {
            throw RequestServiceError("Not valid HTTP")
        }
        return data
    }
    
    
    static func buildRequest(for url:URL, with headers:Dictionary<String,String>? = nil, using method:Method? = nil, containing body:HTTPBody? = nil) -> URLRequest? {
        var request = URLRequest(url: url)
        
        if let headers {
            for (key, value) in headers {
                request.setValue(key, forHTTPHeaderField: value)
            }
        }
        
        if let method {
            request.httpMethod = method.rawValue
        }
        
        if let body {
            guard let bodyData = try? body.encode() else {
                return nil
            }
            for (key, value) in body.additionalHeaders {
                request.setValue(key, forHTTPHeaderField: value)
            }
            
            request.httpBody = bodyData
        }
        
        return request
    }
}
