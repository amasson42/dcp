//
//  SubjectSwift.swift
//  Dcpmaker
//
//  Created by Giantwow on 13/05/2021.
//

import Foundation

public class SubjectSwift: SubjectLanguage {
    
    public init() {
        
    }
    
    public var funcFileName: String { "func.swift" }
    
    public let fileHeader =
        """
/*
 * Daily coding problem
 * Have fun !
 */

import Foundation


"""
    
    public func render(function: SubjectFormat.Function) -> String {
        var rendered = "/* entrypoint */\nfunc \(function.name)("
        let params = function.parameters
        for (index, param) in params.enumerated() {
            rendered += "\(param.name): \(self.format(type: param.type))"
            if index == params.indices.last {
                rendered += ") "
            } else {
                rendered += ", "
            }
        }
        rendered += "-> \(self.format(type: function.returnType)) {\n    /* code */\n}\n"
        return rendered
    }
    
    public func correct(subject: SubjectFormat, withFuncFilePath funcFilePath: String, inWorkspace dir: String, displayTestCode: Bool) throws {
        
        for (index, test) in subject.tests.enumerated() {
            let ziped = zip(subject.function.parameters, test.parameters)
            guard ziped.underestimatedCount == subject.function.parameters.count,
                  ziped.underestimatedCount == test.parameters.count else {
                throw "Unmatching parameters"
            }
            
            print("test[\(index)] \(test.name.debugDescription) ", terminator: "")
            var main =
                """
import Foundation


"""
            
            for (index, param) in ziped.enumerated() {
                main += self.format(initVariable: param.1, toName: "\(param.0.name)_\(index)")
            }
            
            main += "let result = \(subject.function.name)("
            for (index, param) in ziped.enumerated() {
                main += "\(param.0.name): \(param.0.name)_\(index)"
                if index == ziped.underestimatedCount - 1 {
                    main += ")\n"
                } else {
                    main += ", "
                }
            }
            
            var mainWithPrintResult = main + self.format(initVariable: test.expectedReturn, toName: "expected")
            
            mainWithPrintResult += """
var standardError = FileHandle.standardError
extension FileHandle : TextOutputStream {
    public func write(_ string: String) {
        self.write(string.data(using: .utf8)!)
    }
}

"""

            mainWithPrintResult += "print(result, to: &standardError)\n"
            mainWithPrintResult += "exit(result == expected ? 0 : 1)\n"
            
            try mainWithPrintResult.write(toFile: dir + "/main.swift", atomically: true, encoding: .utf8)
            
            let shellCmd = "swiftc \(funcFilePath) \(dir)/main.swift -o \(dir)/tester"
            let compileResult = try shell(shellCmd)
            
            guard compileResult.code == 0 else {
                print("❌ Does not compile")
                print(compileResult.stderr)
                break
            }
            
            let result = try shell("\(dir)/tester")
            
            if result.code == 0 {
                if test.expectedOutput == result.stdout {
                    print("✅")
                } else {
                    print("❌ Wrong output")
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
    
    func format(type: SubjectFormat.ParameterType) -> String {
        switch type {
            case .bool:             return "Bool"
            case .int:              return "Int"
            case .float:            return "Float"
            case .string:           return "String"
            case .array_bool:       return "[Bool]"
            case .array_int:        return "[Int]"
            case .array_float:      return "[Float]"
            case .array_string:     return "[String]"
            case .matrix_bool:      return "[[Bool]]"
            case .matrix_int:       return "[[Int]]"
            case .matrix_float:     return "[[Float]]"
            case .matrix_string:    return "[[String]]"
        }
    }
    
    func format(initVariable variable: SubjectFormat.ValuedParameter, toName name: String) -> String {
        switch variable {
            case .bool(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .int(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .float(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .string(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value.debugDescription)\n"
            case .array_bool(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .array_int(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .array_float(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .array_string(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value.debugDescription)\n"
            case .matrix_bool(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .matrix_int(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .matrix_float(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value)\n"
            case .matrix_string(value: let value):
                return "let \(name): \(self.format(type: variable.type)) = \(value.debugDescription)\n"
        }
    }
    
}
