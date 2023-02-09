//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation



public protocol Authorizable {
    var token:String? { get }
    var serviceKey:String { get }
    var accountKeyBase:String { get }
    //    func setToken(token:String)
    //    func clearToken()
    var isAuthorized:Bool { get }
    //    func authorizedFetch(from:URL, token:String) async throws -> Data
}


extension Authorizable {
    
    //    static func appendAuthorization(to dictionary:[String:String], tokenKey:String, token:String) -> [String:String] {
    //        var copy = dictionary
    //        copy[tokenKey] = token
    //        return copy
    //    }
    
    //Authorization: Bearer our_access_token_here
    
    public func appendAuthHeader(to dictionary:[String:String], token:String) -> [String:String] {
        var copy = dictionary
        copy["Authorization"] = "Bearer \(token)"
        return copy
    }
    
    public func saveTokenToKeyChain(token:String, accountKey:String) {
        let dataIn = Data(token.utf8)
        KeyChainHandler.saveAccessToken(dataIn, service: serviceKey, account: "\(accountKeyBase)_\(accountKey)")
    }
    
    public func readTokenFromKeyChain(accountKey:String) -> String? {
        let dataOut = KeyChainHandler.readAccessToken(service: serviceKey, account: "\(accountKeyBase)_\(accountKey)")
        if let dataOut {
            let accessToken = String(data: dataOut, encoding: .utf8)!
            return accessToken
        } else {
            return nil
        }

    }
    
//    public func updateTokenInKeyChain(newToken:String, for account:String) {
//        saveTokenToKeyChain(token: newToken, accountKey: account)
//    }
}
