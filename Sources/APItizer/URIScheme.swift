//
//  URIScheme.swift
//  
//
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


//https://en.wikipedia.org/wiki/List_of_URI_schemes
public enum Scheme {
    case https
    
    var component:String {
        "https"
    }
    
    var reccomendedRequestService:RequestService {
        HTTPRequestService()
    }
}
