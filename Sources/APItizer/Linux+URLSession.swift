//
//  URLSession+Linux.swift
//
//
//  Created by Carlyn Maw on 2023 May 5th
//

#if os(Linux)
import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

//https://github.com/JohnSundell/AsyncCompatibilityKit/blob/main/Sources/URLSession%2BAsync.swift
//https://www.swiftbysundell.com/articles/retrying-an-async-swift-task/
//https://www.swiftbysundell.com/articles/connecting-async-await-with-other-swift-code/
//https://stackoverflow.com/questions/25203556/returning-data-from-async-call-in-swift-function

//MARK: Data
public extension URLSession {
    //    func data(for request:URLRequest) async throws -> (Data, URLResponse) {
    ////        let mockResponse = HTTPURLResponse(url: request.url!, statusCode: 200, httpVersion: "1.1", headerFields: nil)!
    ////        return (Data(), mockResponse)
    //    }
    

    func data(for request: URLRequest) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?
        let onCancel = { dataTask?.cancel() }
        
        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    dataTask = self.dataTask(with: request) { data, response, error in
                        guard let data = data, let response = response else {
                            let error = error ?? URLError(.badServerResponse)
                            return continuation.resume(throwing: error)
                        }
                        
                        continuation.resume(returning: (data, response))
                    }
                    
                    dataTask?.resume()
                }
            },
            onCancel: {
                onCancel()
            }
        )
    }
    
    func data(from url: URL) async throws -> (Data, URLResponse) {
        try await data(for: URLRequest(url: url))
    }
    
//    func data(from url:URL) async throws -> (Data, URLResponse) {
//        let mockResponse = HTTPURLResponse(url: url, statusCode: 200, httpVersion: "1.1", headerFields: nil)!
//        return (Data(), mockResponse)
//    }
}

//MARK: upload
public extension URLSession {
    func upload(for request: URLRequest, from bodyData:Data, delegate: (URLSessionTaskDelegate)? = nil) async throws -> (Data, URLResponse) {
        var dataTask: URLSessionDataTask?
        let onCancel = { dataTask?.cancel() }
        var rlocal = request
        rlocal.httpMethod = "POST"
        rlocal.httpBody = bodyData
        
        return try await withTaskCancellationHandler(
            operation: {
                try await withCheckedThrowingContinuation { continuation in
                    dataTask = self.dataTask(with: rlocal) { data, response, error in
                        guard let data = data, let response = response else {
                            let error = error ?? URLError(.badServerResponse)
                            return continuation.resume(throwing: error)
                        }
                        
                        continuation.resume(returning: (data, response))
                    }
                    
                    dataTask?.resume()
                }
            },
            onCancel: {
                onCancel()
            }
        )
    }
    
}

#endif

