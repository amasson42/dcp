//
//  Generate+run.swift
//  dcpmaker
//
//  Created by Giantwow on 12/05/2021.
//

import Foundation

fileprivate let fm = FileManager.default

func openWeb(localFile: String) throws {
    #if os(OSX)
    if #available(OSX 10.13, *) {
        let openProcess = Process()
        openProcess.executableURL = URL(fileURLWithPath: "/usr/bin/open")
        openProcess.arguments = [localFile]
        try openProcess.run()
    } else {
        let openProcess = Process()
        openProcess.launchPath = "/usr/bin/open"
        openProcess.arguments = [localFile]
        openProcess.launch()
    }
    #elseif os(Linux)
    let openProcess = Process()
    openProcess.executableURL = URL(fileURLWithPath: "/usr/bin/xdg-open")
    openProcess.arguments = [localFile]
    try openProcess.run()
    #endif
}

extension Dcpmaker.Generate {
    
    mutating func run() {
        print("Generate code for problem \(number) in \(language.rawValue)")
        
        do {
            let workspacePath = Dcpmaker.workspacePath(num: number)
            let configJsonUrl = URL(fileURLWithPath: Dcpmaker.subjectFormatPath(num: number))
            
            try fm.createDirectory(atPath: workspacePath, withIntermediateDirectories: true, attributes: nil)
            
            let subjectFormat = try JSONDecoder().decode(SubjectFormat.self, from: Data(contentsOf: configJsonUrl))
            
            try subjectLanguage.generate(subject: subjectFormat, inWorkspace: workspacePath)
            
            let subjectHtmlPath = Dcpmaker.subjectHtmlPath(num: number)
            print("Opening subject \(subjectHtmlPath)")
            
            try openWeb(localFile: subjectHtmlPath)
            
        } catch {
            print("Error: \(error)")
        }
        
    }
    
}

