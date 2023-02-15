//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  APIService+PostRequests.swift
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation

//TODO: Move meat over to request service?
//The failed cases handling moved over, but wait until implementing a different
//request service type before knocking yourself out. Looks like URLRequest will just ignore HTTP
//related content if it isnt http.

public extension APIService where Self:Authorizable {
    


    //using async upload, see APing for manual body example.
    func post_URLEncoded(baseUrl:URL, formData:Dictionary<String, CustomStringConvertible>, withAuth:Bool = true) async throws -> Data {
        //cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        if withAuth { try addAuth(request: &request) }

        let dataToSend = try URLEncoder.makeURLEncodedString(formItems: formData).data(using: .utf8)

        //Uneeded b/c this appears to be the default.
        //request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return try await requestService.postData(urlRequest: request, data: dataToSend!)

    }
    
    //using async upload, see APing for manual body example.
    func post_URLEncoded(baseUrl:URL, dataToSend:Data, withAuth:Bool = true) async throws -> Data {
        //cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        if withAuth { try addAuth(request: &request) }

        //Uneeded b/c this appears to be the default.
        //request.setValue("application/x-www-form-urlencoded; charset=utf-8", forHTTPHeaderField: "Content-Type")
        
        return try await requestService.postData(urlRequest: request, data: dataToSend)

    }


    func post_FormBody(baseUrl:URL, formData:Dictionary<String, CustomStringConvertible>, withAuth:Bool = true) async throws -> Data {
        let (boundary, dataToSend) = try MultiPartFormEncoder.makeBodyData(formItems: formData, withTermination: true)
        return try await post_FormBody(baseUrl:baseUrl, dataToSend:dataToSend, boundary: boundary, withAuth: withAuth)
    }

    // //Skeptical this works for anything other than URLencode...
    func post_FormBody(baseUrl:URL, dataToSend:Data, boundary:String, withAuth:Bool = true) async throws -> Data {
        //cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        if withAuth { try addAuth(request: &request) }

        //necessary b/c not the default on upload. See APIng
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        return try await requestService.postData(urlRequest: request, data: dataToSend)

    }


    //Using the manual body here just for contrast. See APIng.
    //Will not using explicit uplaod task be a problem if not an HTTP Scheme?
    func post_ApplicationJSON(baseUrl:URL, itemToSend:Encodable, withAuth:Bool = true) async throws -> Data {
        //cachePolicy: URLRequest.CachePolicy, timeoutInterval: TimeInterval
        var request = URLRequest(url: baseUrl)
        request.httpMethod = "POST"
        if withAuth { try addAuth(request: &request) }

        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        let jsonData = try JSONSerialization.data(withJSONObject: itemToSend, options: .fragmentsAllowed)
        request.httpBody = jsonData
        
        return try await requestService.postData(urlRequest: request)

    }
}
