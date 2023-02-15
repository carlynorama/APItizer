//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  URLMaker.swift
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


public enum URLMaker {
    
    public static func urlAssembler(_ pathParts:[String]) -> URL? {
        return URL(string:assemblePath(pathParts, prependSeparator: false))
    }
    
    public static func urlAssembler(_ pathParts:String...) -> URL? {
        return URL(string:assemblePath(pathParts, prependSeparator: false))
    }

    public static func pathAssembler(_ pathParts:String...) -> String? {
        return URL(string:assemblePath(pathParts))?.absoluteString
    }
    
    public static func pathAssembler(_ pathParts:[String]) -> String? {
        return URL(string:assemblePath(pathParts))?.absoluteString
    }

    public static func urlAssembler(url:URL, _ pathParts:String...) -> URL? {
       let urlString = url.absoluteString
        var mPathParts = pathParts
        mPathParts.insert(urlString, at:0)
        return URL(string:assemblePath(mPathParts, prependSeparator: false))
    }

    public static func urlAssembler(baseString:String, _ pathParts:String...) -> URL? {
        var mPathParts = pathParts
        mPathParts.insert(baseString, at:0)
        return URL(string:assemblePath(mPathParts, prependSeparator: false))
    }
    
    static private func assemblePath(_ pathParts:[String], prependSeparator:Bool = true) -> String {
        var joined = prependSeparator ? "/" : ""
            let trimmed:[String] = pathParts.compactMap({
                let part = String($0.trimmingCharacters(in: CharacterSet(charactersIn: "/")))
                if !part.isEmpty { return part }
                else { return nil }
            })
        joined += trimmed.joined(separator: "/")
        return joined
    }


    public static func urlFromPath(scheme:String = "https", host:String, path:String, port:Int? = nil) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        if let port  { components.port = port }

        components.path = path
        
        guard let url = components.url else {
            throw APItizerError("Invalid url for path")
        }
        return url
    }

    public static func urlFromPathComponents(scheme:String = "https", host:String, components pathParts:[String], port:Int? = nil) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        if let port  { components.port = port }

        components.path = assemblePath(pathParts)
        
        guard let url = components.url else {
            throw APItizerError("Invalid url for path")
        }
        return url
    }



    public static func urlFromEndpoint(scheme:String = "https", host:String, apiBase:String = "", endpoint:Endpoint, port:Int? = nil) throws -> URL {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host.trimmingCharacters(in: CharacterSet(charactersIn: "/"))
        if let port  { components.port = port }

        components.path = assemblePath([apiBase, endpoint.path], prependSeparator: true)

        if !endpoint.queryItems.isEmpty {
            components.queryItems = endpoint.queryItems
        }
        
        //print("urlFromEndpoint")
        guard let url = components.url else {
            print("urlFromEndpoint components:\(components)")
            throw APItizerError("Invalid url for endpoint")
        }
        return url
    }
    
}
