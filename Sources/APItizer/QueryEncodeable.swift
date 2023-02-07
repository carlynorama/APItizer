//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation


public protocol QueryEncodable:Codable {
    func makeQueries() -> [URLQueryItem]
}

public extension QueryEncodable {
    
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
            queries.append(URLQueryItem(name: key, value: "\(value)"))
        }
        
        return queries
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
