//
//  SubjectJavascript.swift
//  Dcpmaker
//
//  Created by Giantwow on 17/05/2021.
//

import Foundation

// TODO: All this
public class SubjectJavascript: SubjectLanguage {
    
    public init() {
        fatalError("Javascript is not available yet")
    }
    
    public var funcFileName: String { "func.js" }
    
    public let fileHeader: String =
        """
//
// Daily coding problempublic 
// Have fun !
//

"""
    
    public func render(function: SubjectFormat.Function) -> String {
        var rendered = "//entrypoint\nfunction \(function.name)("
        let params = function.parameters
        for (index, param) in params.enumerated() {
            rendered += param.name
            if index == params.indices.last {
                rendered += ")"
            } else {
                rendered += ", "
            }
        }
        rendered += " {\n    // code\n}\n"
        return rendered
    }
    
    public func correct(subject: SubjectFormat, withFuncFilePath path: String, inWorkspace dir: String, displayTestCode: Bool) throws {
        
    }
    
    
}
