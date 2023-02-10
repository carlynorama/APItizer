//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation

public struct HTTPRequestService:RequestService {
    public enum Method: String {
        case delete = "DELETE", get = "GET", head = "HEAD", patch = "PATCH", post = "POST", put = "PUT"
    }
    
    internal var session:URLSession
    
    public init(session:URLSession = URLSession.shared) {
        self.session = session
    }
    
    //MARK: - Level One Fetch Requests (Hello World)
    
    public func serverHello(from url:URL) async throws -> String {
        let (_, response) = try await session.data(from: url)  //TODO: catch the error here
        //print(response)
        let (isValid, mimeType) = await checkForValidResponse(response)
        return "The url returns a \(isValid ? "valid":"invalid") HTTP response\(isValid ? " of type \(mimeType ?? "unknown")":".")"
    }
    
    public func fetchRawString(from:URL, encoding:String.Encoding = .utf8) async throws -> String {
        let (data, _) = try await session.data(from: from)
        guard let string = String(data: data, encoding: encoding) else {
            throw RequestServiceError("Got data, couldn't make a string with \(encoding)")
        }
        return string
    }
    
    //MARK: - Generic HTTP Handling
    public func fetch(from url:URL) async throws -> Data {
        let (data, response) = try await session.data(from: url)  //TODO: catch the error here
       //print(response)
        guard await checkForValidResponse(response).isValid else {
            throw RequestServiceError("Not valid HTTP")
        }
        
//        if debugLog {
//            let string = String(decoding: data, as: UTF8.self)
//            print(string)
//        }
        return data
    }
    
    public func checkForValidResponse(_ response:URLResponse) async -> (isValid:Bool, mimeType:String?) {
        guard let httpResponse = response as? HTTPURLResponse,
                    (200...299).contains(httpResponse.statusCode) else {
                    self.handleServerError(response)
                    return (false, nil)
        }

        return (true, httpResponse.mimeType)
    }
    
    func handleServerError(_ response:URLResponse) {
        print(response)
    }
    
    func fetch(urlRequest:URLRequest) async throws -> Data {
        let (data, response) = try await session.data(for: urlRequest)
        guard await checkForValidResponse(response).isValid else {
            throw RequestServiceError("Not valid HTTP")
        }
        return data
    }
    
    
    public static func buildRequest(for url:URL, with headers:Dictionary<String,String>? = nil, using method:Method? = nil, sending data:Data? = nil) -> URLRequest? {
        var request = URLRequest(url: url)
        
        if let headers {
            for (key, value) in headers {
                request.setValue(value, forHTTPHeaderField:key)
            }
        }
        
        if let method {
            request.httpMethod = method.rawValue
        }
        
        if let data {
            request.httpBody = data
        }
        
        return request
    }
    
    
    public static func multiPart(formItems:[String:String]?) {
        let boundary = UUID().uuidString
        let header = ["Content-Type":"multipart/form-data; boundary=\(boundary)"]
        
        var data = Data()
        
        if formItems != nil{
            for(key, value) in formItems!{
                data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
                data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
                data.append("\(value)".data(using: .utf8)!)
            }
        }
    }
    
}



//
//    // generate boundary string using a unique per-app string
//    let boundary = UUID().uuidString
//
//    request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
//
//    var data = Data()
//    if parameters != nil{
//        for(key, value) in parameters!{
//            // Add the reqtype field and its value to the raw http request data
//            data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//            data.append("Content-Disposition: form-data; name=\"\(key)\"\r\n\r\n".data(using: .utf8)!)
//            data.append("\(value)".data(using: .utf8)!)
//        }
//    }
//    for (index,imageData) in images.enumerated() {
//        // Add the image data to the raw http request data
//        data.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
//        data.append("Content-Disposition: form-data; name=\"\(imageNames[index])\"; filename=\"\(imageNames[index])\"\r\n".data(using: .utf8)!)
//        data.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
//        data.append(imageData)
//    }
//
//    // End the raw http request data, note that there is 2 extra dash ("-") at the end, this is to indicate the end of the data
//    data.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
//
//    // Send a POST request to the URL, with the data we created earlier
//    session.uploadTask(with: request, from: data, completionHandler: { data, response, error in
//
//        if let checkResponse = response as? HTTPURLResponse{
//            if checkResponse.statusCode == 200{
//                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: [JSONSerialization.ReadingOptions.allowFragments]) else {
//                    completion(nil, error, false)
//                    return
//                }
//                let jsonString = String(data: data, encoding: .utf8)!
//                print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
//                print(json)
//                completion(json, nil, true)
//            }else{
//                guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
//                    completion(nil, error, false)
//                    return
//                }
//                let jsonString = String(data: data, encoding: .utf8)!
//                print("\n\n---------------------------\n\n"+jsonString+"\n\n---------------------------\n\n")
//                print(json)
//                completion(json, nil, false)
//            }
//        }else{
//            guard let data = data, let json = try? JSONSerialization.jsonObject(with: data, options: []) else {
//                completion(nil, error, false)
//                return
//            }
//            completion(json, nil, false)
//        }
//
//    }).resume()
//
//}
//
//extension Data {
//
//    /// Append string to Data
//    ///
//    /// Rather than littering my code with calls to `data(using: .utf8)` to convert `String` values to `Data`, this wraps it in a nice convenient little extension to Data. This defaults to converting using UTF-8.
//    ///
//    /// - parameter string:       The string to be added to the `Data`.
//
//    mutating func append(_ string: String, using encoding: String.Encoding = .utf8) {
//        if let data = string.data(using: encoding) {
//            append(data)
//        }
//    }
//}
