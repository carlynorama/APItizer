//
//  URIScheme.swift
//  
//
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


//https://en.wikipedia.org/wiki/List_of_URI_schemes
public enum URIScheme {
    case https
    
    public var component:String {
        "https"
    }
    
    public var reccomendedRequestService:RequestService {
        HTTPRequestService()
    }
}
