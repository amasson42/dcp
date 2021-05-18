//
//  SubjectJavascript.swift
//  Dcpmaker
//
//  Created by Giantwow on 17/05/2021.
//

import Foundation

class SubjectJavascript: SubjectLanguage {
    
    init() {
        fatalError("Javascript is not available yet")
    }
    
    var funcFileName: String { "func.js" }
    
    let fileHeader: String =
        """
//
// Daily coding problem
// Have fun !
//

"""
    
    func render(function: SubjectFormat.Function) -> String {
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
    
    func correct(subject: SubjectFormat, withFuncFilePath path: String, inWorkspace dir: String, displayTestCode: Bool) throws {
        
    }
    
    
}
