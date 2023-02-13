//
//  Data+JSON.swift
//
//
//  Created by Carlyn Maw on 2/5/23.
//

import Foundation



fileprivate struct NullableObject<Base: Decodable>: Decodable {
    public let value: Base?

    public init(from decoder: Decoder) throws {
        do {
            let container = try decoder.singleValueContainer()
            self.value = try container.decode(Base.self)
        } catch {
            self.value = nil
        }
    }
}

public extension Data {
    
    func asDictionary() async throws -> [String: Any]? {
        let data = self
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(result)
            return result as? [String:Any] //ANy or AnyObject
        } catch {
            print(error)
            return nil
        }
    }
    
    func asFlatDictionary() async throws -> [String: String]? {
        let data = self
        do {
            let result = try JSONSerialization.jsonObject(with: data, options: .fragmentsAllowed)
            print(result)
            return result as? [String:String] //ANy or AnyObject
        } catch {
            print(error)
            return nil
        }
    }
    
    func asValue<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable {
        let data = self
        let decoded = try decoder.decode(SomeDecodable.self, from: data)
        return decoded
    }
    
    func asTransformedValue<SomeDecodable: Decodable, Transformed>(
        ofType: SomeDecodable.Type,
        decoder:JSONDecoder = JSONDecoder(),
        transform: @escaping (SomeDecodable) throws -> Transformed
    ) async throws -> Transformed {
        let data = self
        let decoded = try await data.asValue(ofType: ofType, decoder: decoder)
        return try transform(decoded)
    }
    
    func asOptional<SomeDecodable: Decodable>(ofType:SomeDecodable.Type, decoder:JSONDecoder = JSONDecoder()) async throws -> SomeDecodable? {
        let data = self
        let result = try decoder.decode(NullableObject<SomeDecodable>.self, from: data)
        return result.value
    }
    
    func asCollection<SomeDecodable: Decodable>(ofType:SomeDecodable.Type) async throws -> [SomeDecodable?] {
        let data = self
        let results = try JSONDecoder().decode([NullableObject<SomeDecodable>].self, from: data)
        return results.compactMap { $0.value }
    }
    
    func asCollectionOfOptionals<SomeDecodable: Decodable>(ofType:SomeDecodable.Type) async throws -> [SomeDecodable?] {
        let data = self
        let results = try JSONDecoder().decode([NullableObject<SomeDecodable>].self, from: data)
        return results.map { $0.value }
    }
    
    //from Ed
    func verboseDecode<T:Decodable>(decoder:JSONDecoder = JSONDecoder()) -> T? {
        let data = self
    //    decoder.keyDecodingStrategy = .convertFromSnakeCase
      do {
          
        let object = try decoder.decode(T.self, from: data)
        print(object)
        return object

      } catch DecodingError.dataCorrupted(let context) {
          print(context)
      } catch DecodingError.keyNotFound(let key, let context) {
          print("Key '\(key)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
      } catch DecodingError.valueNotFound(let value, let context) {
          print("Value '\(value)' not found:", context.debugDescription)
          print("codingPath:", context.codingPath)
      } catch DecodingError.typeMismatch(let type, let context) {
          print("Type '\(type)' mismatch:", context.debugDescription)
          print("codingPath:", context.codingPath)
      } catch {
        print(error.localizedDescription)
      }

      return nil
    }
    
}
