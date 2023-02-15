//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  Endpoint.swift
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


public struct Endpoint {
    let path: String
    let queryItems: [URLQueryItem]
    
    public init(path: String, queryItems: [URLQueryItem]) {
        self.path = path
        self.queryItems = queryItems
    }
    
//    mutating public func setQueryItems(from:QueryEncodable) {
//        queryItems = from.makeQueries()
//    }
}
