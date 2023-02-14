//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


public enum QueryEncoder {
    //Always ignores empty and nil values.
    //Arrays are of the forma key=v1,v2,v3
    public static func makeQueryItems(from itemToEncode:Encodable) -> [URLQueryItem] {
        let encoder = JSONEncoder()
        func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
            let data = try encoder.encode(value)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        }
        guard let dictionary = try? encode(itemToEncode) else {
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
        
        return queries
    }
    
    public static func arrayToQueryItems(baseStringForKey:String, array:[CustomStringConvertible]) -> [URLQueryItem] {
        var queries:[URLQueryItem] = []
        queries.reserveCapacity(array.count)
        for item in array {
            queries.append(URLQueryItem(name: "\(baseStringForKey)[]", value: String(describing: item)))
        }
        return queries
    }
    
}





