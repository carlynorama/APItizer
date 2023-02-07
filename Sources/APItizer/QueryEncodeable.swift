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
    func makeQueries() -> [URLQueryItem] {
        let dict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: foo).children.map{ ($0.label!, $0.value) })
        
    }
}
