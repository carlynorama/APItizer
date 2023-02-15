//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  Attachable.swift
//  Created by Carlyn Maw on 2/10/23.
//

import Foundation
import UniformTypeIdentifiers

public struct Attachment:Attachable {
    public var fileName: String
    public var mimeType: String
    public var data: Data
    
    //Not in protocol. TDB if that is right call.
    public var source:URL?
    
    
    public init(fileName: String, mimeType: String, data: Data) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
        self.source = nil
    }
    
    init(fileName: String, mimeType: String, data: Data, source:URL) {
        self.fileName = fileName
        self.mimeType = mimeType
        self.data = data
        self.source = source
    }
    
    public static func makeFromFile(path:String, limitTypes uttypes: [UTType] = [] ) throws -> Attachment {
        let url = URL(fileURLWithPath: path)
        return try makeFrom(url:url, limitTypes:uttypes)
    }
    
    public static func makeFrom(url:URL, limitTypes uttypes: [UTType] = []) throws -> Attachment {
        if !uttypes.isEmpty {
            guard url.pointsToItemOfType(uttypes: uttypes) else {
                throw APItizerError("Attachement: Canidate file does not conform to allowed types.")
            }
        }
        guard let data = try? Data(contentsOf: url) else {
            throw APItizerError("Attachement: No data for the file at the location given.")
        }
       
        //let ext = url.pathExtension
        //var leaf = url.lastPathComponent
//        if !ext.isEmpty {
//            leaf = leaf.split(separator: ".").dropLast().joined(separator: ".") //incase there were other periods in the file name
//        }
        
        return Attachment(fileName: url.lastPathComponent, mimeType:  url.mimeType(), data: data, source: url)
    }


}



public protocol Attachable  {
    var fileName:String { get }
    var mimeType:String { get }
    var data:Data { get }
}

extension Attachable {
    var base64EncondedString: String {
        return "data:\(mimeType);base64,\(data.base64EncodedString())"
    }
}



