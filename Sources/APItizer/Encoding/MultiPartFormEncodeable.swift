//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  MultiPartFormEncodeable.swift
//  Created by Carlyn Maw on 2/10/23.
//

import Foundation


public protocol MultiPartFormEncodeable {
    func makeFormBody(withTermination:Bool) throws ->  (boundary:String, body:Data)
}


//See DictionaryEncoder.makeDictionary(from itemToEncode:Any) for ideas when not encodeable, but non-encodeables shouldn't be using a default.
extension MultiPartFormEncodeable where Self:Encodable {
    
    func makeFormBody(withTermination:Bool = true) throws -> (boundary:String, body:Data) {
        let formItems = DictionaryEncoder.makeDictionary(fromEncodable:self)
        return try MultiPartFormEncoder.makeBodyData(formItems: formItems, withTermination: withTermination)
    }
}
