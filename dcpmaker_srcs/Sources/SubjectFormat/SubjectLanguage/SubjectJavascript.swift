//
//  SubjectJavascript.swift
//  Dcpmaker
//
//  Created by Giantwow on 17/05/2021.
//

import Foundation

public class SubjectJavascript: SubjectLanguage {
    
    public init() {
        //fatalError("Javascript is not available yet")
    }
    
    public var funcFileName: String { "func.js" }
    
    public let fileHeader: String =
        """
//
// Daily coding problem
// Have fun !
//


"""
    
    public func render(function: SubjectFormat.Function) -> String {
        var rendered = "// entrypoint\nexports.\(function.name) = function("
        let params = function.parameters
        for (index, param) in params.enumerated() {
            rendered += "\(param.name) /* \(param.type) */"
            if index == params.indices.last {
                rendered += ")"
            } else {
                rendered += ", "
            }
        }
        let comments = function.comments?.reduce("", { $0 + "    // \($1)\n"} ) ?? ""
        rendered += " {\n\(comments)    // code\n}\n"
        return rendered
    }
    
    public func correct(subject: SubjectFormat, withFuncFilePath path: String, inWorkspace dir: String, displayTestCode: Bool) throws {
        
        for (index, test) in subject.tests.enumerated() {
            print("test[\(index)] \(test.name.debugDescription) ", terminator: "")
            let ziped = zip(subject.function.parameters, test.parameters)
            guard ziped.underestimatedCount == subject.function.parameters.count,
                  ziped.underestimatedCount == test.parameters.count else {
                throw "Unmatching parameters"
            }
            
            var main =
                """

const func = require("../func")

"""
            
            for (index, param) in ziped.enumerated() {
                main += self.format(initVariable: param.1, toName: "\(param.0.name)_\(index)")
            }
            
            main += "let result = func.\(subject.function.name)("
            for (index, param) in ziped.enumerated() {
                main += "\(param.0.name)_\(index)"
                if index == ziped.underestimatedCount - 1 {
                    main += ")\n"
                } else {
                    main += ", "
                }
            }
            
            main += self.format(initVariable: test.expectedReturn, toName: "expected")
            
            var mainWithPrintResult = main
            
            mainWithPrintResult += "process.stderr.write(result)\n"
            mainWithPrintResult += "if (result != expected) { process.exit(1) }\n"
            
            try mainWithPrintResult.write(toFile: dir + "/main.js", atomically: true, encoding: .utf8)
            
            let result = try shell("node \(dir)/main.js")
            
            if result.code == 0 {
                if test.expectedOutput == result.stdout {
                    print("✅")
                } else {
                    print("❌ Wrong output:")
                    print(result.stdout)
                    if !test.expectedOutput.isEmpty {
                        print("expected output:")
                        print(test.expectedOutput)
                    }
                }
            } else {
                print("❌ Wrong result")
                print("result: \(result.stderr)")
            }
            if displayTestCode {
                print("test code:")
                print("```")
                print(main)
                print("```")
            }
            
        }

    }
    
    func format(initVariable variable: SubjectFormat.ValuedParameter, toName name: String) -> String {
        struct JsBool: CustomStringConvertible {
            var value: Bool
            var description: String { value ? "true" : "false" }
        }
        switch variable {
            case .bool(value: let value):
                return "let \(name) = \(JsBool(value: value))\n"
            case .int(value: let value):
                return "let \(name) = \(value)\n"
            case .float(value: let value):
                return "let \(name) = \(value)\n"
            case .string(value: let value):
                return "let \(name) = \(value.debugDescription)\n"
            case .array_bool(value: let value):
                return "let \(name) = \(value.map(JsBool.init))\n"
            case .array_int(value: let value):
                return "let \(name) = \(value)\n"
            case .array_float(value: let value):
                return "let \(name) = \(value)\n"
            case .array_string(value: let value):
                return "let \(name) = \(value.debugDescription)\n"
            case .matrix_bool(value: let value):
                return "let \(name) = \(value.map { $0.map(JsBool.init) })\n"
            case .matrix_int(value: let value):
                return "let \(name) = \(value)\n"
            case .matrix_float(value: let value):
                return "let \(name) = \(value)\n"
            case .matrix_string(value: let value):
                return "let \(name) = \(value.debugDescription)\n"
        }
    }
    
}
