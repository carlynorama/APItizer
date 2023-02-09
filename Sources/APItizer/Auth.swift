//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

////"tipsyrobot"
//mutating public func loadTokenFromKeyChain(for account:String) {
//    if let readToken = readTokenFromKeyChain(accountKey: account) {
//        putTokenInEnvironment(token: readToken, tokenKey: tokenKey)
//    }
//}

//TODO Wrap KeyChain items in #if availalbe

import Foundation

public protocol Authorizable {
    var authentication:Authentication? { get }
    var hasValidToken:Bool { get }
}


public struct Authentication {
    
    public let account:String
    public let service:String
    private let keyBase:String
    private let tokenKey:String

    public static let defaultKeyBase: String = "APItizer_"
    
    public init(account:String, service:String, keyBase:String = Authentication.defaultKeyBase, tokenKey:String? = nil) {
        self.account = account
        self.service = service
        self.keyBase = keyBase
        self.tokenKey = tokenKey ?? "\(keyBase)_\(account)_TOKEN"
    }
    
    static public func makeFromKeyChain(account:String, service:String, keyBase:String = Authentication.defaultKeyBase) throws -> Self {
        let accountKey = "\(keyBase)_\(account)"
        let serviceKey = "\(keyBase)_\(service)"
        let tokenKey = "\(keyBase)_\(account)_TOKEN"
        
        let dataOut = KeyChainHandler.readAccessToken(service: serviceKey, account: accountKey)
        if let dataOut {
            DotEnv.setEnvironment(key: tokenKey, value: String(data: dataOut, encoding: .utf8)!)
        } else {
           throw APIError("Could not locate access token in keychain.")
        }
        
        return Self(account: account, service: service)
    }
    
    static public func makeFromEnvironment(accountName:String, service:String, tokenKey:String) throws -> Self {

        var tokenString = ProcessInfo.processInfo.environment[tokenKey]
        
        if (tokenString == nil) {
            try Self.loadEnvironment()
            tokenString = ProcessInfo.processInfo.environment[tokenKey]
            if (tokenString == nil) {
                throw APIError("Unable to find a token in the environment.")
            }
        }
        return Self(account:accountName, service:service)
    }
    
    static public func makeWithTokenInhand(token:String, account:String, service:String, keyBase:String = Authentication.defaultKeyBase) throws -> Self {
        let tokenKey = "\(keyBase)_\(account)_TOKEN"
        DotEnv.setEnvironment(key: tokenKey, value: token)
        
        return Self(account:account, service:service, keyBase: keyBase, tokenKey: tokenKey)
        
    }
    
    static func secretPushToKeychain(account:String, service:String, keyBase:String = Authentication.defaultKeyBase, token:String) throws {
        let accountKey = "\(keyBase)_\(account)"
        let serviceKey = "\(keyBase)_\(service)"
        let tokenKey = "\(keyBase)_\(account)_TOKEN"
        
        let dataIn = Data(token.utf8)
        KeyChainHandler.saveAccessToken(dataIn, service: serviceKey, account: accountKey)
    }

//   What are the use cases?
//    static public func makeFromEnvironmentAddToKeyChain(accountName:String, service:String, tokenKey:String) throws -> Self {
//
//        var tokenString = ProcessInfo.processInfo.environment[tokenKey]
//
//        if (tokenString == nil) {
//            try Self.loadEnvironment()
//            tokenString = ProcessInfo.processInfo.environment[tokenKey]
//            if (tokenString == nil) {
//                throw APIError("Unable to find a token in the environment.")
//            }
//        }
//        let new = Self(account:accountName, service:service)
//        new.updateTokenInKeyChain(token: tokenString!)
//        return new
//    }
    
    static func loadEnvironment(url:URL? = nil) throws {
        do {
            if let url { try DotEnv.loadDotEnv(url:url) }
            else {
                if let defaultURL = Bundle.main.url(forResource: ".env", withExtension: nil) {
                    try DotEnv.loadDotEnv(url:defaultURL) }}
        } catch {
            throw APIError(error.localizedDescription)
        }
    }
}


extension Authentication {
    
    private func fetchToken() throws -> String {
        guard let token = ProcessInfo.processInfo.environment[tokenKey] else {
            throw APIError("No token in environment")
        }
        return token
    }
    
    public var accountKey:String {
        "\(keyBase)_\(account)"
    }
    
    public var serviceKey:String {
        "\(keyBase)_\(service)"
    }
    
    public func appendAuthHeader(to dictionary:[String:String]) throws -> [String:String] {
        var copy = dictionary
        copy["Authorization"] = "Bearer \(try fetchToken())"
        return copy
    }
    
    
    public func updateTokenInKeyChain(token:String) {
        let dataIn = Data(token.utf8)
        KeyChainHandler.saveAccessToken(dataIn, service: serviceKey, account: accountKey)
    }
    
    private func readTokenFromKeyChain() -> String? {
        let dataOut = KeyChainHandler.readAccessToken(service: serviceKey, account: accountKey)
        if let dataOut {
            let accessToken = String(data: dataOut, encoding: .utf8)!
            return accessToken
        } else {
            return nil
        }
    }
    
//    private func putTokenInEnvironment(token:String) {
//        DotEnv.setEnvironment(key: tokenKey, value: token)
//    }
    
//    func setToken(token: String) {
//        //TODO: confirm with server
//        putTokenInEnvironment(token: token)
//        //saveTokenToKeyChain(token: token, accountKey: accountKey)
//    }
//
//    func setTokenPlusKeyChain(token: String) {
//        //TODO: confirm with server
//        putTokenInEnvironment(token: token)
//        saveTokenToKeyChain(token: token, accountKey: accountKey)
//    }
    

}