//
//  MastodonAPI.swift
//  ActivityPubExplorer
//
//  Created by Labtanza on 10/30/22.
//

import Foundation

public protocol APIService {
    var serverScheme:URIScheme { get }
    var requestService:RequestService { get }
    var serverHost:URL { get }
    var serverPort:Int? { get }
    var defaultAPIBase:String? { get }
    var defaultVersionBase:String? { get }
    var defaultBasePath:String? { get }
}



public extension APIService {
    var name:String {
        serverHost.absoluteString
    }
    
    var defaultBasePath:String? {
        let components = [defaultAPIBase, defaultVersionBase].compactMap( {$0})
        return URLMaker.pathAssembler(components)
    }
    
    //If no base, returns unchanged path. 
//    func prependBase(to path:String) throws -> String {
//        var base = defaultAPIBase ?? ""
//        if let newBase = APItizer.pathAssembler(base, path) {
//            return newBase
//        } else {
//            throw APItizerError("prependBase: could not build path with base.")
//        }
//    }
    
    func urlFromPath(path:String, prependBasePath:Bool = true) throws -> URL {
        var mPathParts = [path]
        if prependBasePath  {
            if let defaultBasePath  {
                mPathParts.insert(defaultBasePath, at: 0)
            }
        }
        return try URLMaker.urlFromPathComponents(scheme:serverScheme.component, host: serverHost.absoluteString, components: mPathParts, port:serverPort)
    }

    func urlFromPathComponents(components pathParts:[String], prependBasePath:Bool = true) throws -> URL {
        var mPathParts = pathParts
        if prependBasePath  {
            if let defaultBasePath  {
                mPathParts.insert(defaultBasePath, at: 0)
            }
        }
        return try URLMaker.urlFromPathComponents(scheme:serverScheme.component, host: serverHost.absoluteString, components: mPathParts, port:serverPort)
    }



    func urlFromEndpoint(endpoint:Endpoint, prependBasePath:Bool = true) throws -> URL {
        var basePath = ""
        if prependBasePath  { let basePath = defaultAPIBase ?? "" }
        return try URLMaker.urlFromEndpoint(scheme:serverScheme.component, host: serverHost.absoluteString, apiBase:basePath, endpoint:endpoint, port:serverPort)
    }
    

    
}
