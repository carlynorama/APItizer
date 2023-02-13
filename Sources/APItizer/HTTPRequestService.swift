//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation



public struct HTTPRequestService:RequestService {
//    public enum Method: String {
//        case delete = "DELETE", get = "GET", head = "HEAD", patch = "PATCH", post = "POST", put = "PUT"
//    }
    
    internal var session:URLSession

    public let scheme:URIScheme = .https
    
    public private(set) var defaultTimeOut:TimeInterval? = nil
    
    public init(session:URLSession = URLSession.shared) {
        self.session = session
    }
}

//MARK: GETs
extension HTTPRequestService {
    
    public func serverHello(from url:URL) async throws -> String {
        
        var request = URLRequest(url: url)
        if let defaultTimeOut { request.timeoutInterval = defaultTimeOut }
        let (_, response) = try await session.data(for: request)  //TODO: catch the error here
        let httpResponse = response as! HTTPURLResponse
        if (200...299).contains(httpResponse.statusCode) {
            return ("success, \(httpResponse.statusCode), \(String(describing:httpResponse.mimeType))")
        } else {
            return ("Not in success range, \(httpResponse.statusCode), \(String(describing:httpResponse.mimeType))")
            //handleServerError(httpResponse)
        }

    }

    public func fetchData(from url:URL) async throws -> Data {
        var request = URLRequest(url: url)
        if let defaultTimeOut { request.timeoutInterval = defaultTimeOut }
        
        let (data, response) = try await session.data(from: url)
        
        //TODO: What if it's not HTTP?
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Not in success range, \(httpResponse.statusCode), \(String(describing:httpResponse.mimeType))")
            //handleServerError(httpResponse)
            throw HTTPRequestServiceError("getData: No data")
        }
        return data
    }

    public func fetchRawString(from url:URL, encoding:String.Encoding = .utf8) async throws -> String {
        var request = URLRequest(url: url)
        if let defaultTimeOut { request.timeoutInterval = defaultTimeOut }
        
        let (data, response) = try await session.data(from: url)
        
        //TODO: What if it's not HTTP?
        let httpResponse = response as! HTTPURLResponse
        guard (200...299).contains(httpResponse.statusCode) else {
            print("Not in success range, \(httpResponse.statusCode), \(String(describing:httpResponse.mimeType))")
            //handleServerError(httpResponse)
            throw HTTPRequestServiceError("getData: No data")
        }
        guard let string = String(data: data, encoding: encoding) else {
            throw HTTPRequestServiceError("Got data, couldn't make a string with \(encoding)")
        }
        return string
    }
    
}


extension HTTPRequestService {
    
    
    public func postData(urlRequest:URLRequest, data:Data) async throws -> Data {
        let (responseData, response) = try await session.upload(for: urlRequest, from: data, delegate: nil)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print(response)
            throw HTTPRequestServiceError("Not an HTTP Response.")
        }
        
         guard (200...299).contains(httpResponse.statusCode)  else  {
             print(response)
             throw HTTPRequestServiceError("Request Failed:\(httpResponse.statusCode), \(String(describing:httpResponse.mimeType))")
         }
        
        
        return responseData
        
    }
    
    public func postData(urlRequest:URLRequest) async throws -> Data {

        let (responseData, response) = try await session.data(for: urlRequest)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            print(response)
            throw HTTPRequestServiceError("Not an HTTP Response.")
        }
        
         guard (200...299).contains(httpResponse.statusCode)  else  {
             print(response)
             throw HTTPRequestServiceError("Request Failed:\(httpResponse.statusCode), \(String(describing:httpResponse.mimeType))")
         }
        
        return responseData
        
    }
    
    
}
