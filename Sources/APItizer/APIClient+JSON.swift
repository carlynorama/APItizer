//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/5/23.
//

import Foundation


public extension APIClient {
    
    //MARK: Generic Object Fetcher
    
    func fetchObject<T:Codable>(ofType:T.Type, fromPath:String) async -> T? {
        do {
            let url = try urlFrom(path: fromPath, usingAPIBase: true)
            //print("URL for Instance Info: \(url)")
            let result = try await scheme.requestService.fetch(from: url).asValue(ofType: ofType)
            //print(result)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
    //MARK: Generic New Type of JSON printer
    func fetchJSON(fromPath:String) async -> String? {
        do {
            let url = try urlFrom(path: fromPath, usingAPIBase: true)
            print("URL for Instance Info: \(url)")
            let result = try await scheme.requestService.fetchRawString(from: url, encoding: .utf8)
            print(result)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
}
public extension APIClient {
    func fetchCollectionOfOptionals<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL) async throws -> [SomeDecodable?] {
        try await scheme.requestService.fetch(from: url).asCollectionOfOptionals(ofType: ofType)
    }
    
    func fetchDictionary(from url:URL) async throws -> [String: Any]? {
        try await scheme.requestService.fetch(from: url).asDictionary()
    }
    
    func fetchValue<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL, decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable {
        try await scheme.requestService.fetch(from: url).asValue(ofType: ofType, decoder:decoder)
    }
    
    func fetchTransformedValue<SomeDecodable: Decodable, Transformed>(
        ofType: SomeDecodable.Type,
        from url:URL,
        transform: @escaping (SomeDecodable) throws -> Transformed
    ) async throws -> Transformed {
        try await scheme.requestService.fetch(from: url).asTransformedValue(ofType: ofType, transform: transform)
    }
    
    func fetchOptional<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL, decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable? {
        try await scheme.requestService.fetch(from: url).asOptional(ofType: ofType)
    }
    
    func fetchCollection<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL) async throws -> [SomeDecodable?] {
        try await scheme.requestService.fetch(from: url).asCollection(ofType: ofType)
    }
}
