//
//  Correct+run.swift
//  dcpmaker
//
//  Created by Giantwow on 13/05/2021.
//

import Foundation

fileprivate let fm = FileManager.default

extension Dcpmaker.Correct {
    
    mutating func run() throws {
        print("Generate code for problem \(number) in \(language.rawValue)")
        
        do {
            let workspacePath = Dcpmaker.workspacePath(num: number)
            let configJsonUrl = URL(fileURLWithPath: Dcpmaker.subjectFormatPath(num: number))
            
            guard fm.directoryExists(atPath: workspacePath) else {
                throw "workspace \(workspacePath) does not exist"
            }
            
            let subjectFormat = try JSONDecoder().decode(SubjectFormat.self, from: Data(contentsOf: configJsonUrl))
            
            let funcFilePath = "\(workspacePath)/\(subjectLanguage.funcFileName)"
            let tmpDir = workspacePath + "/_tmp"
            try fm.createDirectory(atPath: tmpDir, withIntermediateDirectories: true, attributes: nil)
            defer {
                try? fm.removeItem(atPath: tmpDir)
            }
            
            try subjectLanguage.correct(subject: subjectFormat, withFuncFilePath: funcFilePath, inWorkspace: tmpDir, displayTestCode: displayTestCode)
            
        } catch {
            print("Error: \(error)")
        }
    }
    
}
