//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

//TODO Wrap KeyChain & Bundle items in #if availalbe

import Foundation

public protocol Authorizable {
    var authentication:Authentication? { get } //<- am I who I say I am. 
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
        let accountKey = "\(keyBase)\(account)"
        let serviceKey = "\(keyBase)\(service)"
        let tokenKey = "\(keyBase)\(account)_TOKEN"
        
        //print(accountKey, serviceKey)
        
        let dataOut = KeyChainHandler.readAccessToken(service: serviceKey, account: accountKey)
        if let dataOut {
            print("found it.")
            EnvironmentLoading.setEnvironment(key: tokenKey, value: String(data: dataOut, encoding: .utf8)!)
        } else {
            print("did not find it.")
            throw AuthorizableError.noTokenKeychain
        }
        
        return Self(account: account, service: service, tokenKey: tokenKey)
    }
    
    static public func makeFromEnvironment(accountName:String, service:String, tokenKey:String) throws -> Self {

        var tokenString = ProcessInfo.processInfo.environment[tokenKey]
        
        if (tokenString == nil) {
            //if secretsFile == nil {
            try Self.loadIntoEnvironment()
            //} else {
            //    try Self.loadIntoEnvironment(url: secretsFile)
            //}
            tokenString = ProcessInfo.processInfo.environment[tokenKey]
            if (tokenString == nil) {
                throw AuthorizableError.noTokenEnv
            }
        }
        return Self(account:accountName, service:service, tokenKey: tokenKey)
    }
    
    static public func makeWithTokenInhand(token:String, account:String, service:String, keyBase:String = Authentication.defaultKeyBase) throws -> Self {
        let tokenKey = "\(keyBase)_\(account)_TOKEN"
        EnvironmentLoading.setEnvironment(key: tokenKey, value: token)
        
        return Self(account:account, service:service, keyBase: keyBase, tokenKey: tokenKey)
        
    }
    
    func addBearerToken(to request: inout URLRequest) throws {
        request.setValue("Bearer \(try fetchToken())", forHTTPHeaderField: "Authorization")
    }
    
    static func secretPushToKeychain(account:String, service:String, keyBase:String = Authentication.defaultKeyBase, token:String) throws {
        let accountKey = "\(keyBase)_\(account)"
        let serviceKey = "\(keyBase)_\(service)"
        //let tokenKey = "\(keyBase)_\(account)_TOKEN"
        
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
    
    static func loadIntoEnvironment(url:URL? = nil) throws {
            if let url { try EnvironmentLoading.loadSecretsFile(url:url) }
            else { try EnvironmentLoading.loadDotEnv() }
    }
}


extension Authentication {
    
    public var hasStoredToken:Bool {
        if let _ = try? fetchToken() {
            return true
        } else { return false }
    }
    
    func fetchToken() throws -> String {
        //print("\(tokenKey)")
        guard let token = ProcessInfo.processInfo.environment[tokenKey] else {
            throw AuthorizableError.noTokenEnv
        }
        return token
    }
    
    public var accountKey:String {
        "\(keyBase)_\(account)"
    }
    
    public var serviceKey:String {
        "\(keyBase)_\(service)"
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
