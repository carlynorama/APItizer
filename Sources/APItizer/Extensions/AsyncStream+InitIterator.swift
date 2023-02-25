//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/21/23.
//

import Foundation



//TODO: Is this in 5.8???
//https://forums.swift.org/t/when-can-we-move-asyncsequence-forward/61991/2
extension AsyncStream {
  init<S: AsyncSequence>(_ sequence: S) where S.Element == Element {
    var iterator: S.AsyncIterator?
    self.init {
      if iterator == nil {
        iterator = sequence.makeAsyncIterator()
      }
      return try? await iterator?.next()
    }
  }
}
