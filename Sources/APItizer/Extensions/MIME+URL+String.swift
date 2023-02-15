//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  MIME+URL+String.swift
//  Created by Carlyn Maw on 2/11/23.
//  https://stackoverflow.com/questions/31243371/path-extension-and-mime-type-of-file-in-swift

import Foundation
import UniformTypeIdentifiers

extension NSURL {
    public func mimeType() -> String {
        guard let pathExtension else {
            return "application/octet-stream"
        }
        if let mimeType = UTType(filenameExtension: pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}

extension URL {
    public func mimeType() -> String {
        return UTType(filenameExtension: self.pathExtension)?.preferredMIMEType ?? "application/octet-stream"
    }
}

extension URL {
    public func contains(_ uttype: UTType) -> Bool {
        return UTType(mimeType: self.mimeType())?.conforms(to: uttype) ?? false
    }
    
    public func pointsToItemOfType(uttypes: [UTType]) -> Bool {
        guard let mytype = UTType(mimeType: self.mimeType()) else {
            return false
        }
        for t in uttypes {
            if mytype.conforms(to: t) { return true }
        }
        return false
        
    }
}

extension NSString {
    public func mimeType() -> String {
        if let mimeType = UTType(filenameExtension: self.pathExtension)?.preferredMIMEType {
            return mimeType
        }
        else {
            return "application/octet-stream"
        }
    }
}

extension String {
    public func mimeType() -> String {
        return (self as NSString).mimeType()
    }
}





//
//TODO: Actually Implement?
////https://en.wikipedia.org/wiki/List_of_file_signatures
////https://stackoverflow.com/questions/74083113/ios-swift-get-mime-type-from-data
////https://gist.github.com/Qti3e/6341245314bf3513abb080677cd1c93b
//extension Data
//{
//    private static let mimeTypeSignatures: [([UInt8], String)] = [
//        ([0x49, 0x49, 0x2A, 0x00], "image/tiff"),
//        ([0x4D, 0x4D, 0x00, 0x2A], "image/tiff"),
//        ([0x89, 0x50, 0x4E, 0x47, 0x0D, 0x0A, 0x1A, 0x0A], "image/png"),
//        ([0xFF, 0xD8], "image/jpeg"),
//        //...
//    ]
//
//    var mimeType: String
//    {
//        let tenFirstBytes = Array(subdata(in: 0..<10))
//        return Data.mimeTypeSignatures.filter
//                   { signature in
//                       tenFirstBytes.starts(with: signature.0)
//                   }
//                   .first?.1 ?? "application/octet-stream"
//    }
//}


//extension Data {
//    private static let mimeTypeSignatures: [UInt8 : String] = [
//        0xFF : "image/jpeg",
//        0x89 : "image/png",
//        0x47 : "image/gif",
//        0x49 : "image/tiff",
//        0x4D : "image/tiff",
//        0x25 : "application/pdf",
//        0xD0 : "application/vnd",
//        0x46 : "text/plain",
//        ]
//
//    var mimeType: String {
//        var c: UInt8 = 0
//        copyBytes(to: &c, count: 1)
//        return Data.mimeTypeSignatures[c] ?? "application/octet-stream"
//    }
//}






    
//    //Example:
//    let fileUrl = URL(string: "../myFile.png")!
//    print(fileUrl.contains(.image))
//    print(fileUrl.contains(.video))
//    print(fileUrl.contains(.text))

    
//    var containsAudio: Bool {
//        let mimeType = self.mimeType()
//        if let type = UTType(mimeType: mimeType) {
//            return type.conforms(to: .audio)
//        }
//        return false
//    }


//
//
//import AVFoundation
//
//public extension AVFileType {
//    /// Fetch and extension for a file from UTI string
//    var fileExtension: String {
//        guard let type = UTType(self.rawValue),
//              let preferredFilenameExtension = type.preferredFilenameExtension
//        else {
//            return "None"
//        }
//        return preferredFilenameExtension
//    }
//}
