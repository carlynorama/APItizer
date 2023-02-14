//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/14/23.
//

import Foundation

public extension APIService where Self:Authorizable {
    public func addAuth(request: inout URLRequest) throws {
        print(self)
        print("addAuth: hasValidToken \(self.hasValidToken)")
        if let auth = self.authentication {
            try auth.addBearerToken(to:&request)
        } else {
            throw AuthorizableError("No authorizations defined.")
        }
    }
}
