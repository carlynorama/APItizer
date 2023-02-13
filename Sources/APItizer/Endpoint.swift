//
//  File.swift
//  
//
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
}