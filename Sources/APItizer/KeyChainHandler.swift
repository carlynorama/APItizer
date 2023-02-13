//
//  KeyChainHandler.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//
// https://www.andyibanez.com/posts/using-ios-keychain-swift/
// https://swiftsenpai.com/development/persist-data-using-keychain/

// TODO: What happens in Linux

import Foundation


public enum KeyChainHandler {
    
    
//    //let tag = "com.example.keys.mykey".data(using: .utf8)!
//    public func saveToken(token:String, tag:String) throws {
//        let key = token
//        let tag = tag.data(using: .utf8)!
//        let addquery: [String: Any] = [kSecClass as String: kSecClassKey,
//                                       kSecAttrApplicationTag as String: tag,
//                                       kSecValueRef as String: key]
//        let status = SecItemAdd(addquery as CFDictionary, nil)
//        guard status == errSecSuccess else { throw APIError("couldn't save key") }
//    }
//
//    public func getSavedToken(tag:String) -> [String: Any] {
//        [kSecClass as String: kSecClassKey,
//         kSecAttrApplicationTag as String: tag,
//         kSecAttrKeyType as String: kSecAttrKeyTypeRSA,
//         kSecReturnRef as String: true]
//    }
    
    public static func saveAccessToken(_ data: Data, service: String, account: String) {
        
        // Create query
        let query = [
            kSecValueData: data,
            kSecClass: kSecClassGenericPassword,
            kSecAttrService: service,
            kSecAttrAccount: account,
        ] as CFDictionary
        
        // Add data in query to keychain
        let status = SecItemAdd(query, nil)
        
        if status == errSecDuplicateItem {
            // Item already exist, thus update it.
            let query = [
                kSecAttrService: service,
                kSecAttrAccount: account,
                kSecClass: kSecClassGenericPassword,
            ] as CFDictionary
            
            let attributesToUpdate = [kSecValueData: data] as CFDictionary
            
            // Update existing item
            SecItemUpdate(query, attributesToUpdate)
        }
    }
    
    public static func readAccessToken(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary
        
        var result: AnyObject?
        SecItemCopyMatching(query, &result)
        
        return (result as? Data)
    }
}
