//
//  APItizer
//  https://github.com/carlynorama/APItizer
//
//  String+AttributedString.swift
//  Created by Carlyn Maw on 10/30/22.
//
//
import Foundation

// print(String(data: data, encoding: .utf8)!)

public extension String {
    //Usage
    //List(ExampleText.harderHTMLTests, id:\.self) { item in
    //    Text(item.listCrasher() ?? "Nothing to see").id(UUID()) <- Will need id() somewhere if view scrolls
    //}
    //Parses emoji's correctly by adding characterEncoding option.
    func parseAsHTML() -> AttributedString? {
        let data = Data(self.utf8)
        return try? AttributedString(NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,  .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil))
     }
    
    //Usage
    //List(ExampleText.harderHTMLTests, id:\.self) { item in
    //    Text(item.htmlToAttributedString()).id(UUID())  <-Will need id() somewhere if view scrolls
    //}
    func catchingParseAsHTML() -> AttributedString {
        do {
            let data = Data(self.utf8)
            let result = try AttributedString(NSAttributedString(data: data, options: [.documentType: NSAttributedString.DocumentType.html,  .characterEncoding:String.Encoding.utf8.rawValue], documentAttributes: nil))
            return result
        } catch {
            return AttributedString("Error parsing HTML: \(error)")
        }
    }
    
    func parseAsMarkdown() -> AttributedString? {
        return try? AttributedString(markdown: self)
    }
    
    func catchingParseAsMarkdown() -> AttributedString {
        do {
            return try AttributedString(markdown: self)
        } catch {
            return AttributedString("Error parsing HTML: \(error)")
        }
    }
    
    func linkedText(url: URL) -> AttributedString {
        var attributes = AttributeContainer()
        attributes.link = url

        let link = AttributedString(self, attributes: attributes)

        var string = AttributedString()
        string.append(link)
        return string
    }
}
