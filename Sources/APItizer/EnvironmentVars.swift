//
//  File.swift
//  
//
//  Created by Carlyn Maw on 2/7/23.
//

import Foundation

enum EnvironmentVars {
    
    //should prefer ProcessInfo.processInfo.environment["KEY"]
    static func getEnvironmentVar(_ key: String) -> String? {
        guard let rawValue = getenv(key) else { return nil }
        return String(utf8String: rawValue)
    }
    static func setEnvironment(key:String, value:String, overwrite: Bool = false) {
        setenv(key, value, overwrite ? 1 : 0)
    }
    
    static func loadDotEnv() throws {
        if let url = Bundle.main.url(forResource: ".env", withExtension: nil) {
            try loadDotEnv(url: url)
        } else {
            //TODO: throw
            fatalError("no env file")
        }
    }
    
    static func loadDotEnv(url:URL) throws {
        //let url = URL(fileURLWithPath: ".env")
        guard let envString = try? String(contentsOf: url) else {
           fatalError("no env file data")
        }
        envString
            .trimmingCharacters(in: .newlines)
            .split(separator: "\n")
            .lazy //may or maynot save anything
            .filter({$0.prefix(1) != "#"})  //is comment
            .map({ $0.split(separator: "=").map({String($0.trimmingCharacters(in: CharacterSet(charactersIn:"\"\'")))}) })
            .forEach({  addToEnv(result: $0) })

        func addToEnv(result:Array<String>) {
            if result.count == 2  {
                setEnvironment(key: result[0], value: result[1], overwrite: true)
            } else {
                //item would of had to have contained more than 1 "=" or none at all. I'd like to know about that for now.
                print("Failed dotenv add: \(result)")
            }
        }
    }
    

}

