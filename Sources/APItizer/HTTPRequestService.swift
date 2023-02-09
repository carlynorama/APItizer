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
                print("setting key \(key) to \(value)")
                request.setValue(value, forHTTPHeaderField:key)
            }
        }
        
        if let method {
            request.httpMethod = method.rawValue
        }
        
        if let data {
//            guard let bodyData = try? body.encode() else {
//                return nil
//            }
//            for (key, value) in body.additionalHeaders {
//                request.setValue(value, forHTTPHeaderField: key)
//            }
            request.httpBody = data
        }
        
        return request
    }
    
    
    
    
}

//
//let Url = String(format: "http://10.10.10.53:8080/sahambl/rest/sahamblsrv/userlogin")
//    guard let serviceUrl = URL(string: Url) else { return }
//    let parameters: [String: Any] = [
//        "request": [
//                "xusercode" : "YOUR USERCODE HERE",
//                "xpassword": "YOUR PASSWORD HERE"
//        ]
//    ]
//    var request = URLRequest(url: serviceUrl)
//    request.httpMethod = "POST"
//    request.setValue("Application/json", forHTTPHeaderField: "Content-Type")
//    guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters, options: []) else {
//        return
//    }
//    request.httpBody = httpBody
//    request.timeoutInterval = 20
//    let session = URLSession.shared
//    session.dataTask(with: request) { (data, response, error) in
//        if let response = response {
//            print(response)
//        }
//        if let data = data {
//            do {
//                let json = try JSONSerialization.jsonObject(with: data, options: [])
//                print(json)
//            } catch {
//                print(error)
//            }
//        }
//    }.resume()
//}
