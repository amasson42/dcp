//
//  Dcpmaker.swift
//  dcpmaker
//
//  Created by Giantwow on 12/05/2021.
//

import ArgumentParser
import Foundation

extension Range where Element == Int {
    var argDisplay: String {
        if self.lowerBound == self.upperBound - 1 {
            return "[\(self.lowerBound)]"
        } else {
            return "[\(self.lowerBound)-\(self.upperBound - 1)]"
        }
    }
}

struct Dcpmaker: ParsableCommand {
    
    static func workspacePath(num: Int) -> String {
        "workspace/dcp-\(num)"
    }
    static func subjectFormatPath(num: Int) -> String {
        "subjects/dcp-\(num)/format.json"
    }
    static func subjectHtmlPath(num: Int) -> String {
        "subjects/dcp-\(num)/index.html"
    }
    
    static var subjectRange: Range<Int> = {
        var lower = 0
        while !FileManager.default.fileExists(atPath: Self.subjectFormatPath(num: lower)) {
            lower += 1
            if lower > 1000000 {
                fatalError("No problem found")
            }
        }
        var higher = lower + 1
        while FileManager.default.fileExists(atPath: Self.subjectHtmlPath(num: higher)) {
            higher += 1
        }
        return lower..<higher
    }()
    
    enum Language: String, CaseIterable, ExpressibleByArgument {
        case Swift = "swift"
        case Python = "py"
        case Cpp = "cpp"
        case Javascript = "js"
        case Rust = "rs"
        case Go = "go"
        
        func makeSubject() -> SubjectLanguage {
            switch self {
                case .Swift:      return SubjectSwift()
                case .Python:     return SubjectPython()
                case .Cpp:        return SubjectCpp()
                case .Javascript: return SubjectJavascript()
                case .Rust:       return SubjectRust()
                case .Go:         return SubjectGo()
            }
        }
    }
    
    static let configuration = CommandConfiguration(
        abstract: "Exercices and Correction utilities",
        subcommands: [Generate.self, Correct.self]
    )
    
    struct Generate: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Generate the placeholder for your code"
        )
        
        // @Flag(help: "Le flag")
        // var shouldBegin = false
        
        // @Option(name: .shortAndLong, help: "num times")
        // var count: Int?
        
        @Argument(help: "The language to use \(Language.allCases.map(\.rawValue))") var language: Language
        
        lazy var subjectLanguage: SubjectLanguage = self.language.makeSubject()
        
        @Argument(help: "The number of the problem \(Dcpmaker.subjectRange.argDisplay)") var number: Int
        
    }
    
    struct Correct: ParsableCommand {
        static let configuration = CommandConfiguration(
            abstract: "Test if the code passes the tests"
        )
        
        @Argument(help: "The language to use \(Language.allCases.map(\.rawValue))") var language: Language
        
        lazy var subjectLanguage: SubjectLanguage = self.language.makeSubject()
        
        @Argument(help: "The number of the problem \(Dcpmaker.subjectRange.argDisplay)") var number: Int
        
        @Flag(name: .shortAndLong, help: "Display the test code")
        var displayTestCode = false
        
    }
    
}
