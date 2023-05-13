//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  APIService+GetRequests.swift
//  Created by Carlyn Maw on 2/5/23.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

public extension APIService {
    func serverHello(from url:URL) async throws -> String {
        try await requestService.serverHello(from: url)
    }
    func fetchRawString(from:URL, encoding:String.Encoding) async throws -> String {
        try await requestService.fetchRawString(from: from, encoding: encoding)
    }

    func fetch(from url:URL) async throws -> Data {
        try await requestService.fetchData(from: url)
    }
    
}


public extension APIService where Self:Authorizable {
    
    func makeAuthorizedGetRequest(url:URL, withAuth:Bool = true) throws -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        if withAuth { try addAuth(request: &request) }
        return request
    }
    
    func fetchData(from url:URL, withAuth:Bool = true) async throws -> Data {
        let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
        let result = try await requestService.fetchData(for:request)
        return result
    }
    
    func fetchObject<T:Codable>(ofType:T.Type, from endPoint:Endpoint, withAuth:Bool = true) async -> T? {
        do {
            let url = try urlFrom(endpoint: endPoint)
            let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
            let result = try await requestService.fetchData(for:request).asValue(ofType: ofType)
            //print(result)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
    //MARK: Generic Object Fetcher
    
    func fetchObject<T:Codable>(ofType:T.Type, from url:URL, withAuth:Bool = true) async -> T? {
        do {
            let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
            let result = try await requestService.fetchData(for:request).asValue(ofType: ofType)
            //print(result)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
    
    func fetchCollectionOfOptionals<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL, withAuth:Bool = true) async throws -> [SomeDecodable?] {
        let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
        return try await requestService.fetchData(for:request).asCollectionOfOptionals(ofType: ofType)
    }
    
    func fetchDictionary(from url:URL, withAuth:Bool = true) async throws -> [String: Any]? {
        let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
        return try await requestService.fetchData(for:request).asDictionary()
    }
    
    func fetchValue<SomeDecodable: Decodable>(
        ofType:SomeDecodable.Type,
        from url:URL,
        withAuth:Bool = true,
        decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable {
            let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
            return try await requestService.fetchData(for:request).asValue(ofType: ofType, decoder:decoder)
    }
    
    func fetchTransformedValue<SomeDecodable: Decodable, Transformed>(
        ofType: SomeDecodable.Type,
        from url:URL,
        withAuth:Bool = true,
        transform: @escaping (SomeDecodable) throws -> Transformed
    ) async throws -> Transformed {
        let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
        return try await requestService.fetchData(for:request).asTransformedValue(ofType: ofType, transform: transform)
    }
    
    func fetchOptional<SomeDecodable: Decodable>(
        ofType:SomeDecodable.Type,
        from url:URL,
        withAuth:Bool = true,
        decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable? {
            let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
            return try await requestService.fetchData(for:request).asOptional(ofType: ofType)
    }
    
    func fetchCollection<SomeDecodable: Decodable>(
        ofType:SomeDecodable.Type,
        from url:URL,
        withAuth:Bool = true
    ) async throws -> [SomeDecodable?] {
        let request = try makeAuthorizedGetRequest(url: url, withAuth: withAuth)
        return try await requestService.fetchData(for:request).asCollection(ofType: ofType)
    }
}

public extension APIService {
    func fetchObject<T:Codable>(ofType:T.Type, from endPoint:Endpoint) async -> T? {
        do {
            let url = try urlFrom(endpoint: endPoint)
            //print("URL for Instance Info: \(url)")
            let result = try await requestService.fetchData(from: url).asValue(ofType: ofType)
            //print(result)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
    //MARK: Generic Object Fetcher
    
    func fetchObject<T:Codable>(ofType:T.Type, from url:URL) async -> T? {
        do {
            //print("URL for Instance Info: \(url)")
            let result = try await requestService.fetchData(from: url).asValue(ofType: ofType)
            //print(result)
            return result
        } catch {
            print(error)
        }
        return nil
    }
    
    func fetchCollectionOfOptionals<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL) async throws -> [SomeDecodable?] {
        try await requestService.fetchData(from: url).asCollectionOfOptionals(ofType: ofType)
    }
    
    func fetchDictionary(from url:URL) async throws -> [String: Any]? {
        try await requestService.fetchData(from: url).asDictionary()
    }
    
    func fetchValue<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL, decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable {
        try await requestService.fetchData(from: url).asValue(ofType: ofType, decoder:decoder)
    }
    
    func fetchTransformedValue<SomeDecodable: Decodable, Transformed>(
        ofType: SomeDecodable.Type,
        from url:URL,
        transform: @escaping (SomeDecodable) throws -> Transformed
    ) async throws -> Transformed {
        try await requestService.fetchData(from: url).asTransformedValue(ofType: ofType, transform: transform)
    }
    
    func fetchOptional<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL, decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable? {
        try await requestService.fetchData(from: url).asOptional(ofType: ofType)
    }
    
    func fetchCollection<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, from url:URL) async throws -> [SomeDecodable?] {
        try await requestService.fetchData(from: url).asCollection(ofType: ofType)
    }
}


