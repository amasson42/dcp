//
//  SubjectRust.swift
//  Dcpmaker
//
//  Created by Giantwow on 17/05/2021.
//

import Foundation

// TODO: All this
class SubjectRust: SubjectLanguage {
    
    init() {
        fatalError("Rust is not available yet")
    }
    
    var funcFileName: String { "func.rs" }
    
    let fileHeader: String =
        """

"""
    
    func render(function: SubjectFormat.Function) -> String {
        ""
    }
    
    func correct(subject: SubjectFormat, withFuncFilePath path: String, inWorkspace dir: String, displayTestCode: Bool) throws {
        
    }
    
}
