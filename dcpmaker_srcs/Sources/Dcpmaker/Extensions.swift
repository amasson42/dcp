//
//  Extensions.swift
//  Dcpmaker
//
//  Created by Giantwow on 14/05/2021.
//

import Foundation

extension String: Error {}

extension FileManager {
    
    func directoryExists(atPath path: String) -> Bool {
        var isDir: ObjCBool = true
        let exist = self.fileExists(atPath: path, isDirectory: &isDir)
        return exist && isDir.boolValue
    }
    
}

/**
 * Syncronously start a shell command
 * Default shell path = "/bin/bash"
 */
@discardableResult
func shell(_ command: String, shellPath: String = "/bin/bash", stdin: Any? = nil) throws -> (stdout: String, stderr: String, code: Int32) {
    let task = Process()
    let stdoutPipe = Pipe()
    let stderrPipe = Pipe()
    
    task.standardOutput = stdoutPipe
    task.standardError = stderrPipe
    if let stdin = stdin {
        task.standardInput = stdin
    }
    task.arguments = ["-c", command]
    
    #if os(OSX)
    if #available(OSX 10.13, *) {
        task.executableURL = URL(fileURLWithPath: shellPath)
        try task.run()
    } else {
        task.launchPath = shellPath
        task.launch()
    }
    #elseif os(Linux)
    task.executableURL = URL(fileURLWithPath: shellPath)
    try task.run()
    #endif
    
    let stdoutData = stdoutPipe.fileHandleForReading.readDataToEndOfFile()
    let stderrData = stderrPipe.fileHandleForReading.readDataToEndOfFile()
    let stdout = String(data: stdoutData, encoding: .utf8)!
    let stderr = String(data: stderrData, encoding: .utf8)!
    
    task.waitUntilExit()
    
    return (stdout, stderr, task.terminationStatus)
}

