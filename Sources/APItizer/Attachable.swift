//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/10/23.
//

import Foundation
import UniformTypeIdentifiers

public struct MinimalAttachable:Attachable {
    public var attachmentName: String
    public var mimeType: String
    public var data: Data
    public var ext:String?
    
    
    public init(attachmentName: String, mimeType: String, data: Data, ext:String? = nil) {
        self.attachmentName = attachmentName
        self.mimeType = mimeType
        self.data = data
        self.ext = ext
    }
    
    public static func makeFromFile(url:URL, limitTypes uttypes: [UTType] = []) throws -> MinimalAttachable {
        if !uttypes.isEmpty {
            guard url.pointsToItemOfType(uttypes: uttypes) else {
                throw APIError("MinimalAttachable: Does not conform to allowed types.")
            }
        }
        guard let data = try? Data(contentsOf: url) else {
            throw APIError("MinimalAttachable:No data for the file at the location given.")
        }
        let mimeType = url.mimeType()
        let ext = url.pathExtension
        var leaf = url.lastPathComponent
        if !ext.isEmpty {
            leaf = leaf.split(separator: ".").dropLast().joined(separator: ".") //incase there were other periods in the file name
        }
        
        return MinimalAttachable(attachmentName: leaf, mimeType: mimeType, data: data, ext: ext)
    }


}

public protocol Attachable  {
    var attachmentName:String { get }
    var mimeType:String { get }
    var data:Data { get }
    var ext:String? { get }
}

extension Attachable {
    var base64EncondedString: String {
        return "data:\(mimeType);base64,\(data.base64EncodedString())"
    }
}



