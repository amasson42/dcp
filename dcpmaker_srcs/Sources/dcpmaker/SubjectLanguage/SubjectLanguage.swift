//
//  SubjectLanguage.swift
//  dcpmaker
//
//  Created by Giantwow on 13/05/2021.
//

import Foundation

protocol SubjectLanguage {
    
    var funcFileName: String { get }
    var fileHeader: String { get }
    func render(function: SubjectFormat.Function) -> String
    func renderFuncFile(subject: SubjectFormat) -> String
    func generate(subject: SubjectFormat, inWorkspace dir: String) throws
    func correct(subject: SubjectFormat, withFuncFilePath path: String, inWorkspace dir: String, displayTestCode: Bool) throws
    
}

extension SubjectLanguage {
    
    func renderFuncFile(subject: SubjectFormat) -> String {
        return self.fileHeader + render(function: subject.function)
    }
    
    func generate(subject: SubjectFormat, inWorkspace workspacePath: String) throws {
        let funcFile = "\(workspacePath)/\(self.funcFileName)"
        try self.renderFuncFile(subject: subject)
            .write(toFile: funcFile, atomically: true, encoding: .utf8)
        print("generated file: \(funcFile)")
    }
    
}
