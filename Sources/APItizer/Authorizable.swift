//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation



public protocol Authorizable {
    var token:String? { get }
    func setToken(token:String)
    var isAuthorized:Bool { get }
}

extension Authorizable {
    var isAuthorized:Bool {
        token != nil
    }
    
    func setToken(token:String) {
        token = token
    }
    
}
