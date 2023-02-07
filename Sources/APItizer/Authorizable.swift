//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation



public protocol Authorizable {
    var token:String? { get }
    func setToken(token:String)
    func clearToken()
    var isAuthorized:Bool { get }
    func authorizedFetch(from:URL, token:String) async throws -> Data
}


extension Authorizable {
    
    static func appendAuthorization(to dictionary:[String:String], tokenKey:String, token:String) -> [String:String] {
        var copy = dictionary
        copy[tokenKey] = token
        return copy
    }
}
