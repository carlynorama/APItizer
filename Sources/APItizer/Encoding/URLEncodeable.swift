//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation

//use with "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
public protocol URLEncodable:Encodable {
    func makeURLEncodedString() throws -> String
    func makeURLEncodedData() throws -> Data
}

public extension URLEncodable {
    func makeURLEncodedString() throws -> String {
        try URLEncoder.makeURLEncodedString(from: self)
    }

    //
    //    func makeURLEncodedData() throws -> Data {
    //        return Data(try makeURLEncodedString().utf8)
    //    }
    //

    //
    //    private func urlEncode(_ queryItem: URLQueryItem) -> String {
    //        let name = urlEncode(queryItem.name)
    //        let value = urlEncode(queryItem.value ?? "")
    //        return "\(name)=\(value)"
    //    }
    //
    //    private func urlEncode(_ string: String) -> String {
    //        let allowedCharacters = CharacterSet.alphanumerics
    //        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    //    }
}
