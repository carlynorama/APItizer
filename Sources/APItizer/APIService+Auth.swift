//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  APIService+Auth.swift
//  Created by Carlyn Maw on 2/14/23.
//

import Foundation

public extension APIService where Self:Authorizable {
    func addAuth(request: inout URLRequest) throws {
        //print(self)
        //might also consider checking validation. 
        //print("addAuth: hasValidToken \(self.hasValidToken)")
        if let auth = self.authentication {
            try auth.addBearerToken(to:&request)
        } else {
            throw AuthorizableError("No authorizations defined.")
        }
    }
}
