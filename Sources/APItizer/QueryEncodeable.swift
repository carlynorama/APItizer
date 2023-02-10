//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

//TODO: Go back to using Mirror?

import Foundation


public protocol QueryEncodable:Codable {
    func makeQueries() -> [URLQueryItem]
    
    //use with "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    func makeURLEncodedData() throws -> Data
}

public extension QueryEncodable {
    //Always ignores empty and nil values.
    //Arrays are of the forma key=v1,v2,v3
    func makeQueries() -> [URLQueryItem] {
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
        
        return queries
    }
    
    static var headerForEncoded:[String:String] {
        ["Content-Type": "application/x-www-form-urlencoded; charset=utf-8"]
    }
    
    var headerForEncoded:[String:String] {
        Self.headerForEncoded
    }
    
    func makeURLEncodedData() throws -> Data {
        return Data(try makeURLEncodedString().utf8)
    }
    
    func makeURLEncodedString() throws -> String {
        let pieces = makeQueries().map(self.urlEncode)
        let bodyString = pieces.joined(separator: "&")
        return bodyString
    }

    private func urlEncode(_ queryItem: URLQueryItem) -> String {
        let name = urlEncode(queryItem.name)
        let value = urlEncode(queryItem.value ?? "")
        return "\(name)=\(value)"
    }

    private func urlEncode(_ string: String) -> String {
        let allowedCharacters = CharacterSet.alphanumerics
        return string.addingPercentEncoding(withAllowedCharacters: allowedCharacters) ?? ""
    }
}



//Failed but interesting:
//This is the fast brittle way
//    func makeQueries() -> [URLQueryItem] {
//        var queries:[URLQueryItem] = []
//        let dict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: self).children.map{
//            print("type: \(type(of: $0.value))")
//            let test = Mirror(reflecting: $0.value).subjectType
//            if test == Optional<Bool>.self { print("its a Bool optional") }
//            //if test !=  { print("got \($0.value)") }
//            return ($0.label!, "\($0.value)")
//        })
//        for (key, value) in dict {
//            if (value != "nil") {
//                queries.append(URLQueryItem(name: key, value: value))
//            }
//        }
//        return queries
//    }

//    func makeQueries() -> [URLQueryItem] {
//        Mirror(reflecting: self).children.map{
//            print("type: \(type(of: $0.value))")
//            let test = Mirror(reflecting: $0.value).displayStyle
//            print(test)
//            if test == .optional { print("its an optional \($0.value)") }
//            //if test !=  { print("got \($0.value)") }
//            let value = "7"
//            return URLQueryItem(name: $0.label!, value: value)
//        }
//    }

// Revisit Mirror using this?
//var displayableOptions:[String] {
//    let mirror = Mirror(reflecting: self)
//    var itemsToDisplay:[String] = []
//
//    for child in mirror.children  {
//        //print("key: \(child.label), value: \(child.value)")
//        if child.value is ExpressibleByNilLiteral  {
//            let typeDescription = object_getClass(child.value)?.description() ?? ""
//            if !typeDescription.contains("Null") && !typeDescription.contains("Empty") {
//                itemsToDisplay.append(child.label ?? "no_key")
//            }
//        }
//    }
//    return itemsToDisplay
//}
