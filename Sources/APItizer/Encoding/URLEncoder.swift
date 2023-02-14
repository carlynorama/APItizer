//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


//MARK: URLEncoding
public enum URLEncoder {
    
    //URLEncoded
    public static var header:[String:String] {
        ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    }
    
    public static func makeURLEncodedString(from itemToEncode:Encodable) throws -> String {
        try makeURLEncodedString(queryItems:QueryEncoder.makeQueryItems(from: itemToEncode))
        }
    
    public static func makeURLEncodedString(formItems:Dictionary<String, CustomStringConvertible>) throws -> String {
        var urlQueryItems:[URLQueryItem] = []
        for (key, value) in formItems {
            urlQueryItems.append(URLQueryItem(name:key, value:String(describing:value)))
        }
        return try makeURLEncodedString(queryItems:urlQueryItems)
    }
    

    public static func makeURLEncodedString(queryItems:[URLQueryItem]) throws -> String {
        let pieces = queryItems.map(urlEncode)
        let bodyString = pieces.joined(separator: "&")
        return bodyString
    }
    
    static private func urlEncode(_ queryItem: URLQueryItem) -> String {
        let name = urlEncode(queryItem.name)
        let value = urlEncode(queryItem.value ?? "")
        return "\(name)=\(value)"
    }
    
    static private func urlEncode(_ string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
}
