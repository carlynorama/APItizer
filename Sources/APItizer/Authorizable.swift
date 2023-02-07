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
    func clearToken()
    var isAuthorized:Bool { get }
}
