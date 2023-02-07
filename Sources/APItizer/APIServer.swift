//
//  MastodonAPI.swift
//  ActivityPubExplorer
//
//  Created by Labtanza on 10/30/22.
//

import Foundation


public enum APIError: Error, CustomStringConvertible {
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

public enum Scheme {
    case https
    
    var component:String {
        "https"
    }
    
    var requestService:RequestService {
        HTTPRequestService()
    }
    
}

public struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    public init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
    }
}

public protocol APIServer {
    var scheme:Scheme { get }
    var host:URL { get }
    var apiBase:String? { get }
    var version:String? { get }
}

public extension APIServer {
    var name:String {
        host.absoluteString
    }
    
    //TODO: a path sanitizer.
    
    func urlFrom(path:String, usingAPIBase:Bool = false) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme.component
        components.host = host.absoluteString
        if apiBase != nil && usingAPIBase {
            components.path = apiBase! + path
        } else {
            components.path = path
        }
        
        guard let url = components.url else {
            throw APIError("Invalid url for path")
        }
        print(url)
        return url
    }
    
    func urlFrom(endpoint:Endpoint, usingAPIBase:Bool = true) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme.component
        components.host = host.absoluteString
        print("host:\(components.host ?? "none")")
        
        //print("apiBase:\(components.host)")
        
        if apiBase != nil && usingAPIBase {
            components.path = apiBase! + endpoint.path
        } else {
            components.path = endpoint.path
        }
        
        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        
        guard let url = components.url else {
            print("components:\(components)")
            throw APIError("Invalid url for endpoint")
        }
        print(url)
        return url
    }
    

    
}
