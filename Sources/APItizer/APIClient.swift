//
//  MastodonAPI.swift
//  ActivityPubExplorer
//
//  Created by Labtanza on 10/30/22.
//

import Foundation

public protocol APIClient {
    var serverScheme:Scheme { get }
    var requestService:RequestService { get }
    var serverHost:URL { get }
    var serverPort:Int? { get }
    var defaultApiBase:String? { get }
    var defaultVersionBase:String? { get }
}



public extension APIClient {
    var name:String {
        serverHost.absoluteString
    }
    
    var defaultBasePath:String? {
        let components = [defaultApiBase, defaultVersionBase].compactMap( {$0})
        return APItizer.pathAssembler(components)
    }
    
    
    func urlFromPath(path:String) throws -> URL {
        try APItizer.urlFromPath(scheme:serverScheme.component, host: serverHost.absoluteString, path: path, port:serverPort)
    }

    func urlFromPathComponents(components pathParts:[String]) throws -> URL {
        try APItizer.urlFromPathComponents(scheme:serverScheme.component, host: serverHost.absoluteString, components: pathParts, port:serverPort)
    }



    func urlFromEndpoint(endpoint:Endpoint) throws -> URL {
        try APItizer.urlFromEndpoint(scheme:serverScheme.component, host: serverHost.absoluteString, apiBase:apiBase, endpoint:endpoint, port:serverPort)
    }
    

    
}
