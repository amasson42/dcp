//
//  SubjectPython.swift
//  Dcpmaker
//
//  Created by Giantwow on 13/05/2021.
//

import Foundation

public class SubjectPython: SubjectLanguage {
    
    public init() {
        
    }
    
    public var funcFileName: String { "func.py" }
    
    public let fileHeader =
        """
#
# Daily coding problem
# Have fun !
#


"""
    
    public func render(function: SubjectFormat.Function) -> String {
        var rendered = "#entrypoint\ndef \(function.name)("
        let params = function.parameters
        for (index, param) in params.enumerated() {
            rendered += param.name
            if index == params.indices.last {
                rendered += ")"
            } else {
                rendered += ", "
            }
        }
        rendered += ":\n    # code\n\n"
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
from __future__ import print_function
import os, sys
sys.path.append(os.path.dirname(os.path.dirname(os.path.abspath(__file__))))
from func import \(subject.function.name)


"""
            
            for (index, param) in ziped.enumerated() {
                main += self.format(initVariable: param.1, toName: "\(param.0.name)_\(index)")
            }
            
            main += "result = \(subject.function.name)("
            for (index, param) in ziped.enumerated() {
                main += "\(param.0.name)_\(index)"
                if index == ziped.underestimatedCount - 1 {
                    main += ")\n"
                } else {
                    main += ", "
                }
            }
            
            var mainWithPrintResult = main + self.format(initVariable: test.expectedReturn, toName: "expected")
            
            mainWithPrintResult += """

def eprint(*args, **kwargs):
    print(*args, file=sys.stderr, **kwargs)


"""
            
            mainWithPrintResult += "eprint(result)\n"
            mainWithPrintResult += "exit(0 if result == expected else 1)\n"

            try mainWithPrintResult.write(toFile: dir + "/main.py", atomically: true, encoding: .utf8)
            
            let result = try shell("python3 \(dir)/main.py")
            
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
    
    func format(initVariable variable: SubjectFormat.ValuedParameter, toName name: String) -> String {
        struct PyBool: CustomStringConvertible {
            var value: Bool
            var description: String { value ? "True" : "False" }
        }
        switch variable {
            case .bool(value: let value):
                return "\(name) = \(PyBool(value: value))\n"
            case .int(value: let value):
                return "\(name) = \(value)\n"
            case .float(value: let value):
                return "\(name) = \(value)\n"
            case .string(value: let value):
                return "\(name) = \(value.debugDescription)\n"
            case .array_bool(value: let value):
                return "\(name) = \(value.map(PyBool.init))\n"
            case .array_int(value: let value):
                return "\(name) = \(value)\n"
            case .array_float(value: let value):
                return "\(name) = \(value)\n"
            case .array_string(value: let value):
                return "\(name) = \(value.debugDescription)\n"
            case .matrix_bool(value: let value):
                return "\(name) = \(value.map { $0.map(PyBool.init) })\n"
            case .matrix_int(value: let value):
                return "\(name) = \(value)\n"
            case .matrix_float(value: let value):
                return "\(name) = \(value)\n"
            case .matrix_string(value: let value):
                return "\(name) = \(value.debugDescription)\n"
        }
    }
}
