//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/8/23.
//

import Foundation



public protocol FormEncodable:Codable {
    func makeFormPayload() -> Data
}

public extension FormEncodable {

    //Always ignores empty and nil values.
    //Arrays are of the forma key=v1,v2,v3
    func makeFormPayload() -> Data {
        let encoder = JSONEncoder()
        func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
            let data = try encoder.encode(value)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        }
        guard let dictionary = try? encode(self) else {
            //print("got nothing")
            return []
        }
        var queries:[URLQueryItem] = []
        for (key, value) in dictionary {
            var stringValue = "\(value)"
            if stringValue == "(\n)" { stringValue = "" }
            if stringValue.hasPrefix("(") { stringValue = stringValue.trimmingCharacters(in: CharacterSet(charactersIn: "()")).removingCharacters(in: .whitespacesAndNewlines)}
            //print(stringValue)
            if !stringValue.isEmpty  {
                queries.append(URLQueryItem(name: key, value: "\(stringValue)"))
            }
        }
        
        return Data(queries)
    }
}
