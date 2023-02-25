//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/25/23.
//

import Foundation



//This was written for the ServerSentEventListener.

extension AsyncSequence where Element == UInt8 {
    //Works.
    //TODO: https://github.com/apple/swift-async-algorithms/blob/ed0b086089f4e9ac76b3cb6138f578c25e661f34/Sources/AsyncAlgorithms/AsyncBufferedByteIterator.swift
    var allLines_v1:AsyncThrowingStream<String, Error> {
        
        AsyncThrowingStream { continuation in
            //with a U+000D CARRIAGE RETURN U+000A LINE FEED (CRLF) character pair, a single U+000A LINE FEED (LF) character not preceded by a U+000D CARRIAGE RETURN (CR) character, and a single U+000D CARRIAGE RETURN (CR) character not followed by a U+000A LINE FEED (LF) character being the ways in which a line can end.
            //let lineBreaks:[UInt8] = [13,10] //U+000D CARRIAGE RETURN, U+000A LINE FEED (LF)
            let bytesTask = Task {
                var accumulator:[UInt8] = []
                var iterator = self.makeAsyncIterator()
                var CRFlag = false
                while let byte = try await iterator.next() {
                    if CRFlag || byte == 10 {
                        if accumulator.isEmpty { continuation.yield("") }
                        else {
                            if let line = String(data: Data(accumulator), encoding: .utf8) { continuation.yield(line) }
                            else { throw APItizerError("allLines: Couldn't make string from [UInt8] chunk") }
                            accumulator = []
                        }
                    } else {
                        accumulator.append(byte)
                    }
                    CRFlag = (byte == 13)
            }   }
            continuation.onTermination = { @Sendable _ in
                bytesTask.cancel()
    }   }   }
    
    //This code... looses bytes? Looses every-other packet somehow?
    //Something isn't right with the accumulator.
    //setting it to [] or not doesn't seem to make a difference, and it should?
//    var allLines_v2:AsyncThrowingStream<String, Error> {
//        return AsyncThrowingStream {
//            var accumulator:[UInt8] = []
//            for try await byte in self {
//                //10 == \n
//                if byte != 10 { accumulator.append(byte) }
//                else {
//                    if accumulator.isEmpty { return "" }
//                    else {
//                        //print(String(data: Data(accumulator), encoding: .utf8))
//                        if let line = String(data: Data(accumulator), encoding: .utf8) {
//                            //accumulator = [];
//                            print("allLines_v2: \(line)")
//                            return line
//                        }
//                        else {
//                            //accumulator = [];
//                            throw MastodonAPIError("allLines: Couldn't make string from [UInt8] chunk") }
//             }    }   }
//            return nil
//        }
//    }
}

