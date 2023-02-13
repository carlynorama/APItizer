//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/10/23.
//

import Foundation

//https://github.com/Swiftodon/Mastodon.swift/Sources/MastodonSwift/Networking/MultipartFormData.swift
//https://stackoverflow.com/questions/55361096/upload-image-with-multipart-form-data-only-in-swift-4-2
//https://stackoverflow.com/questions/4526273/what-does-enctype-multipart-form-data-mean/28380690#28380690

public protocol FormBodyEncodeable {
    func makeFormBody() -> MultiPartFormBuilder?
}

public struct MultiPartFormBuilder {
    let boundary = UUID().uuidString
    private var data:Data
    
    public init() {
        data = Data()
    }
    
    public var hasData:Bool {
        !data.isEmpty
    }
    
    public var contentTypeHeader:String {
        "multipart/form-data; boundary=\(boundary)"
    }
    
    private var termination:Data {
        "\r\n--\(boundary)--\r\n".data(using: .utf8)!
    }
    
    public var terminatedPayload:Data {
        data.appending(termination) as Data
    }
    
    public var terminatedPayloadString:String? {
        String(data:data.appending(termination) as Data, encoding:.utf8)
    }
    
    public var currentState:Data {
        data as Data
    }
    
    mutating public func appendTextField(named name: String, value: String) {
        data.append(textFormField(label: name, value: value))
    }
    
    mutating public func appendQueryEncodable<T:QueryEncodable>(object:T) {
        let queries = object.makeQueries()
        for query in queries {
            if let value = query.value {
                data.append(textFormField(label: query.name, value: value))
            }
        }
    }
    
    mutating public func appendPreEncodedData(label key: String, data: Data, mimeType: String) {
        self.data.append(dataFormField(label: key, data: data, mimeType: mimeType))
    }
    
    mutating public func appendAttachment(attachment:Attachable) {
        self.data.append(dataFormField(label: attachment.attachmentName, data: attachment.data, mimeType: attachment.mimeType))
    }
    
    private func textFormField(label key: String, value: String) -> String {
         var fieldString = "--\(boundary)\r\n"
         fieldString += "Content-Disposition: form-data; name=\"\(key)\"\r\n"
         fieldString += "Content-Type: text/plain; charset=UTF-8\r\n"
         fieldString += "\r\n"
         fieldString += "\(value)\r\n"

         return fieldString
     }
    
    private func dataFormField(label key: String, data: Data, mimeType: String) -> Data {
        var fieldData = Data()

        fieldData.append("--\(boundary)\r\n")
        fieldData.append("Content-Disposition: form-data; name=\"\(key)\"\r\n")
        fieldData.append("Content-Type: \(mimeType)\r\n")
        fieldData.append("\r\n")
        fieldData.append(data)
        fieldData.append("\r\n")

        return fieldData as Data
    }
    
}

extension Data {
    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
        if let data = string.data(using: encoding) {
            append(data)
        }
    }
    
    func appending(_ string: String, using encoding: String.Encoding = .utf8) throws -> Self? {
        if let data = string.data(using: encoding) {
            var copy = self
            copy.append(data)
            return copy
        } else {
            throw APItizerError("Failed to append data from string.")
        }
    }
    
    func appending(_ newData:Data) -> Self {
        var copy = self
        copy.append(newData)
        return copy
    }
}

//
//var data = Data()
//if parameters != nil{
//    for(key, value) in parameters!{
//        // Add the reqtype field and its value to the raw http request data
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//        data.append("\(value)".data(using: .utf8)!)
//    }
//}
//for (index,imageData) in images.enumerated() {
//    // Add the image data to the raw http request data
//    data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//    data.append("Content-Disposition: form-data; name=\"\(imageNames[index])\"; filename=\"\(imageNames[index])\"\r\n".data(using: .utf8)!)
//    data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//    data.append(imageData)
//}
//
//// End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
//data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
