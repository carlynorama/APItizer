//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

//TODO: Go back to using Mirror?

import Foundation


public protocol QueryEncodable:Encodable {
    func makeQueries() -> [URLQueryItem]
    
    //use with "Content-Type": "application/x-www-form-urlencoded; charset=utf-8"
    func makeURLEncodedData() throws -> Data
}

public extension QueryEncodable {
    //Always ignores empty and nil values.
    //Arrays are of the forma key=v1,v2,v3
    func makeQueries() -> [URLQueryItem] {
        return QueryEncoder.makeQueryItems(from: self)
    }
}
    

