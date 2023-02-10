//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/10/23.
//

import Foundation

public protocol Attachable  {
    var attachmentName:String { get }
    var mimeType:String { get }
    var data:Data { get }
    
}
extension Attachable {
    var base64EncondedString: String {
        return "data:\(mimeType);base64,\(data.base64EncodedString())"
    }
}


