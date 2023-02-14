//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/13/23.
//


//https://github.com/Swiftodon/Mastodon.swift/Sources/MastodonSwift/Networking/MultipartFormData.swift
//https://stackoverflow.com/questions/55361096/upload-image-with-multipart-form-data-only-in-swift-4-2
//https://stackoverflow.com/questions/4526273/what-does-enctype-multipart-form-data-mean/28380690#28380690

import Foundation

//MARK: Multipart Form Encoding
//https://www.rfc-editor.org/rfc/rfc7578
public enum MultiPartFormEncoder {
    
    public static func header(boundary:String) -> [String:String] {
        ["Content-Type": "multipart/form-data; boundary=\(boundary)"]
    }
    
    public static func makeBodyData(formItems:Dictionary<String, CustomStringConvertible>, withTermination:Bool = true) throws -> (boundary:String, body:Data) {
        let boundary = "Boundary--\(UUID().uuidString)"
        var bodyData = Data()
        for (key, value) in formItems {
            bodyData = try appendTextField(data: bodyData, label: key, value: String(describing: value), boundary: boundary)
        }
        if withTermination {
            bodyData = appendTerminationBoundary(data: bodyData, boundary: boundary)
        }
        return (boundary, bodyData)
    }

    //Media uploads will fail if fileName is not included, regardless of MIME/Type.
    public static func makeBodyData(stringItems:Dictionary<String, CustomStringConvertible>, attachments:[String:Attachable], withTermination:Bool = true) throws -> (boundary:String, body:Data) {
        let boundary = "Boundary--\(UUID().uuidString)"
        var bodyData = Data()
        for (key, value) in stringItems {
            bodyData = try appendTextField(data: bodyData, label: key, value: String(describing: value), boundary: boundary)
        }

        for (key, value) in attachments {
            bodyData = try appendDataField(data: bodyData, label: key, dataToAdd: value.data, mimeType: value.mimeType, fileName: value.fileName, boundary: boundary)
        }
        
        if withTermination {
            bodyData = appendTerminationBoundary(data: bodyData, boundary: boundary)
        }
        return (boundary, bodyData)
    }

    //TODO: All this copying... inout instead? make extension?

    static func appendTextField(data:Data, label key: String, value: String, boundary:String) throws -> Data {
        var copy = data
        let formFieldData = try textFormField(label:key, value:value, boundary:boundary)
        copy.append(formFieldData)
        return copy
    }

    static func appendDataField(data:Data, label key: String, dataToAdd: Data, mimeType: String, fileName:String? = nil, boundary:String) throws -> Data {
        var copy = data
        let formFieldData = try dataFormField(label:key, data: dataToAdd, mimeType: mimeType, fileName:fileName, boundary:boundary)
        copy.append(formFieldData)
        return copy
    }
    
    static func appendEncodable<T:Encodable>(data:Data, object:T, boundary:String) throws -> Data {
        var copy = data
        let queries = QueryEncoder.makeQueryItems(from: object)
        for query in queries {
            if let value = query.value {
                copy.append(try textFormField(label: query.name, value: value, boundary: boundary))
            }
        }
        return copy
    }

    static func appendTerminationBoundary(data:Data, boundary:String) -> Data {
        var copy = data
        let boundaryData = "--\(boundary)--".data(using: .utf8)
        copy.append(boundaryData!) //TODO throw instead
        return copy
    }


    static func textFormField(label key: String, value: String, boundary:String) throws -> Data {
        var fieldString = "--\(boundary)\r\n"
        fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
        fieldString += "Content-Type: text/plain; charset=UTF-8\r\n"
        fieldString += "\r\n"
        fieldString += "\(value)\r\n"

       let fieldData = fieldString.data(using: .utf8)
       if fieldData == nil {
        throw APItizerError("couldn't make data from field \(key), \(value) with \(boundary)")
       }
        return fieldData!
    }

    static func dataFormField(label key: String, data: Data, mimeType: String, fileName:String? = nil, boundary:String) throws -> Data {
        var fieldData = Data()

        try fieldData.append("--\(boundary)\r\n")
        if let fileName {
            try fieldData.append("Content-Disposition: form-data; name=\"\(key)\"; filename=\"\(fileName)\";\r\n")
        } else {
            try fieldData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n")
        }
        
        try fieldData.append("Content-Type: \(mimeType)\r\n")
        try fieldData.append("\r\n")
        fieldData.append(data)
        try fieldData.append("\r\n")

        return fieldData as Data
    }

}
