//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation


protocol QueryEncodable:Codable {
    func makeQueries() -> [URLQueryItem]
}

extension QueryEncodable {
    //This is the fast brittle way
    func makeQueries() -> [URLQueryItem] {
        var queries:[URLQueryItem] = []
        let dict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: self).children.map{ ($0.label!, "\($0.value)") })
        for (key, value) in dict {
            if (value != "nil") {
                queries.append(URLQueryItem(name: key, value: value))
            }
        }
        return queries
    }
}
