//
//  SubjectRust.swift
//  Dcpmaker
//
//  Created by Giantwow on 17/05/2021.
//

import Foundation

// TODO: All this
public class SubjectRust: SubjectLanguage {
    
    public init() {
        fatalError("Rust is not available yet")
    }
    
    public var funcFileName: String { "func.rs" }
    
    public let fileHeader: String =
        """

"""
    
    public func render(function: SubjectFormat.Function) -> String {
        ""
    }
    
    public func correct(subject: SubjectFormat, withFuncFilePath path: String, inWorkspace dir: String, displayTestCode: Bool) throws {
        
    }
    
}
