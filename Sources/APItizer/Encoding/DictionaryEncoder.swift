//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  DictionaryEncoder.swift
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


public enum DictionaryEncoder {
    
    func makeDictionary(from itemToEncode:Any) -> [String:String]? {
    let mirror = Mirror(reflecting: itemToEncode)
    var dictionary:[String:String] = [:]

    for child in mirror.children  {
        if let key:String = child.label {
            //print("key: \(key), value: \(child.value)")
            //print(child.value)
            //print(String(describing: child.value))
            if child.value is ExpressibleByNilLiteral  {
                switch child.value {
                    case Optional<Any>.none: print("Nil!")
                    default: 
                        let (_, some) = Mirror(reflecting: child.value).children.first!
                        //print(some)
                        dictionary[key] = String(describing: some)
                }
            } else {
                dictionary[key] = String(describing: child.value)
            }
        } 
        else { print("No key.") }
    }
    return dictionary
}


        //Look at QueryEncoder for other clean up tasks.
    public static func makeDictionary(fromEncodable itemToEncode:Encodable) -> [String:String] {
        let encoder = JSONEncoder()
        func encode<T>(_ value: T) throws -> [String: Any] where T : Encodable {
            let data = try encoder.encode(value)
            return try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any]
        }
        guard let dictionary = try? encode(itemToEncode) else {
            //print("got nothing")
            return [:]
        }
        var cleanedUp:[String:String] = [:]
        for (key, value) in dictionary {
            var stringValue = "\(value)"
            if stringValue == "(\n)" { stringValue = "" }
            if stringValue.hasPrefix("(") { stringValue = stringValue.trimmingCharacters(in: CharacterSet(charactersIn: "()\n"))}
            //print(stringValue)
            if !stringValue.isEmpty  {
                cleanedUp[key] = "\(stringValue)"
            }
        }
        
        return cleanedUp
    }

}



//TODO: Other ways to make dictionaries with a mirror to think more about.
//let dict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: self).children.map{
//    print("type: \(type(of: $0.value))")
//    let test = Mirror(reflecting: $0.value).subjectType
//    if test == Optional<Bool>.self { print("its a Bool optional") }
//    //if test !=  { print("got \($0.value)") }
//    return ($0.label!, "\($0.value)")
//})
//
//let dict = Dictionary(uniqueKeysWithValues: Mirror(reflecting: self).children.map{
//    print("type: \(type(of: $0.value))")
//    let test = Mirror(reflecting: $0.value).displayStyle
//    if test == .optional { print("its an optional \($0.value)") }
//    return ($0.label!, "\($0.value)")
//})

