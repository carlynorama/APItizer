//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/13/23.
//

import Foundation


extension String {
    func removingCharacters(in characters:CharacterSet) -> Self {
        Self(self.unicodeScalars.filter {
            !characters.contains($0)
        })
    }
    func removingCharacters(in string:String) -> Self {
        Self(self.unicodeScalars.filter {
            !CharacterSet(charactersIn:string).contains($0)
        })
    }
    
    func replacingCharacters(in characters:CharacterSet, with newChar:Character) -> Self {
        String(self.compactMap( {
            CharacterSet(charactersIn: "\($0)").isSubset(of: characters)
             ? newChar : $0
        }))
    }
    
    func replacingCharacters(in string:String, with newChar:Character) -> Self {
        String(self.compactMap( {
            CharacterSet(charactersIn: "\($0)").isSubset(of: CharacterSet(charactersIn:string))
             ? newChar : $0
        }))
    }
}
