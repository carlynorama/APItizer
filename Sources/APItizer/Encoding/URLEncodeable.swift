//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  URLEncodeable.swift
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
    
    func makeURLEncodedData() throws -> Data {
        return Data(try makeURLEncodedString().utf8)
    }
}
