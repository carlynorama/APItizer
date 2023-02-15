//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  Data+Append.swift
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation



extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) throws {
        if let data = string.data(using: encoding) {
            append(data)
        } else {
            throw APItizerError("extension Data append: Couldn't make data from string")
        }
    }
    
    func appending(_ string: String, using encoding: String.Encoding = .utf8) throws -> Self? {
        if let data = string.data(using: encoding) {
            var copy = self
            copy.append(data)
            return copy
        } else {
            throw APItizerError("extension Data appending: Couldn't make data from string.")
        }
    }
}
