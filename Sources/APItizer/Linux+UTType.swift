//
//  URLSession+Linux.swift
//
//
//  Created by Carlyn Maw on 2023 May 5th
//  https://www.iana.org/assignments/media-types/media-types.xhtml

#if !canImport(UniformTypeIdentifiers)


//Bad implementation as a stop gap to make existing functionality work. What is the status of 
//UniformTypeIdentifiers???   

//Used functions
//UTType(filenameExtension: pathExtension)?.preferredMIMEType
//url.pointsToItemOfType(uttypes: uttypes)
//UTType(mimeType: self.mimeType())?.conforms(to: uttype)
//mytype = UTType(mimeType: self.mimeType())

public struct UTType:Hashable, Equatable {
    let superType:String
    let subType:String
    let ext:[String]

    public var preferredFilenameExtension:String {
        if ext.count > 0 {
            return ext[0]
        }
        else {
            return ""
        }
    }

    public var preferredMIMEType:String {
        "\(superType)/\(subType)"
    }

    public func conforms(to type:UTType) -> Bool {
        if self == type { return true }
        if type.subType == "" && (self.superType == type.superType) {
            return true
        }
        return false
    }
    


    public static let png = UTType(superType: "image", subType: "png", ext: ["png"])
    public static let jpg = UTType(superType: "image", subType: "jpeg", ext: ["jpg", "jpeg"])
    public static let pdf = UTType(superType: "application", subType: "pdf", ext: ["pdf"])

    public static let knownMimes:[UTType] = [png, jpg, pdf]

    public static let image = UTType(superType: "image", subType: "", ext:[])
        
    }
    
    extension UTType {
    init?(mimeType: String) {
        let split = mimeType.split(separator:"/")
        let possibles = Self.knownMimes.filter { $0.subType == split[1] }
        if  possibles.count == 0 {
            print("Unknown, Can't make without knowing preferred extension")
            return nil
        }
        if possibles.count == 1 {
            self = possibles[0]
        } else {
            print("Too many options:\(possibles)")
            return nil
        }
    }

    init?(filenameExtension: String) {
        let possibles = Self.knownMimes.filter { $0.ext.contains(filenameExtension) }
        if  possibles.count == 0 {
            print("Unknown")
            return nil
        }
        if possibles.count == 1 {
            self = possibles[0]
        } else {
            print("Too many options:\(possibles)")
            return nil
        }
    }

    }

// init?(String)
// Creates a type based on an identifier.
// init?(mimeType: String, conformingTo: UTType)
// Creates a type based on a MIME type and a supertype that it conforms to.
// init?(filenameExtension: String, conformingTo: UTType)
// Creates a type based on a filename extension and an existing supertype that it conforms to.
// init?(tag: String, tagClass: UTTagClass, conformingTo: UTType?)
// Creates a type based on a tag, a tag class, and a supertype that it conforms to.
// init(exportedAs: String, conformingTo: UTType?)
// Creates a type your app owns based on an identifier and a supertype that it conforms to.
// init(importedAs: String, conformingTo: UTType?)
// Creates a type your app uses, but doesn’t own, based on an identifier and a supertype that it conforms to.


//     var preferredFilenameExtension: String?
// The preferred filename extension for the type.
// var preferredMIMEType: String?
// The preferred MIME type for the type.
// var tags: [UTTagClass : [String]]
// The tag specification dictionary of the type.






#endif
