//
//  SubjectCpp.swift
//  Dcpmaker
//
//  Created by Giantwow on 13/05/2021.
//

import Foundation

public class SubjectCpp: SubjectLanguage {
    
    public init() {
        
    }
    
    public var funcFileName: String { "func.cpp" }
    
    public let fileHeader =
        """
//
// Daily coding problem
// Have fun !
//

#include <iostream>
#include <vector>


"""
    
    fileprivate func renderSignature(function: SubjectFormat.Function) -> String {
        var rendered = "\(self.format(type: function.returnType)) \(function.name)("
        let params = function.parameters
        for (index, param) in params.enumerated() {
            rendered += "\(self.format(type: param.type)) \(param.name)"
            if index == params.indices.last {
                rendered += ")"
            } else {
                rendered += ", "
            }
        }
        return rendered
    }
    
    public func render(function: SubjectFormat.Function) -> String {
        return "//entrypoint\n"
            + renderSignature(function: function)
            + " {\n    // code\n}\n"
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
#include <iostream>
#include <vector>


"""
            
            main += renderSignature(function: subject.function) + ";\n"

            main += "int main() {\n"
            
            for (index, param) in ziped.enumerated() {
                main += self.format(initVariable: param.1, toName: "\(param.0.name)_\(index)")
            }
            
            main += "\(self.format(type: test.expectedReturn.type)) result = \(subject.function.name)("
            for (index, param) in ziped.enumerated() {
                main += "\(param.0.name)_\(index)"
                if index == ziped.underestimatedCount - 1 {
                    main += ");\n"
                } else {
                    main += ", "
                }
            }

            var mainWithPrintResult = main + self.format(initVariable: test.expectedReturn, toName: "expected")

            mainWithPrintResult += "std::cerr << result;\nreturn result == expected ? 0 : 1;\n}\n"

            try mainWithPrintResult.write(toFile: dir + "/main.cpp", atomically: true, encoding: .utf8)

            let compileResult = try shell("g++ \(funcFilePath) \(dir)/main.cpp -o \(dir)/tester")

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
            case .bool:             return "bool"
            case .int:              return "int"
            case .float:            return "float"
            case .string:           return "std::string"
            case .array_bool:       return "std::vector<bool>"
            case .array_int:        return "std::vector<int>"
            case .array_float:      return "std::vector<float>"
            case .array_string:     return "std::vector<std::string>"
            case .matrix_bool:      return "std::vector<std::vector<bool> >"
            case .matrix_int:       return "std::vector<std::vector<int> >"
            case .matrix_float:     return "std::vector<std::vector<float> >"
            case .matrix_string:    return "std::vector<std::vector<std::string> >"
        }
    }
    
    func format(initVariable variable: SubjectFormat.ValuedParameter, toName name: String) -> String {
        func sb(_ b: Bool) -> String {
            b ? "true" : "false"
        }
        switch variable {
            case .bool(let value):
                return "bool \(name) = \(sb(value));\n"
            case .int(let value):
                return "int \(name) = \(value);\n"
            case .float(let value):
                return "float \(name) = \(value);\n"
            case .string(let value):
                return "std::string \(name) = \(value.debugDescription);\n"
            case .array_bool(let value):
                var ret = "std::vector<bool> \(name)(\(value.count), false);\n"
                for (index, elem) in value.enumerated() {
                    ret += "\(name)[\(index)] = \(sb(elem));\n"
                }
                return ret
            case .array_int(value: let value):
                var ret = "std::vector<int> \(name)(\(value.count), 0);\n"
                for (index, elem) in value.enumerated() {
                    ret += "\(name)[\(index)] = \(elem);\n"
                }
                return ret
            case .array_float(value: let value):
                var ret = "std::vector<float> \(name)(\(value.count), 0);\n"
                for (index, elem) in value.enumerated() {
                    ret += "\(name)[\(index)] = \(elem);\n"
                }
                return ret
            case .array_string(value: let value):
                var ret = "std::vector<std::string> \(name)(\(value.count));\n"
                for (index, elem) in value.enumerated() {
                    ret += "\(name)[\(index)] = \(elem.debugDescription);\n"
                }
                return ret
            case .matrix_bool(value: let value):
                var ret = "std::vector<std::vector<bool> > \(name)(\(value.count));\n"
                for (index, elem) in value.enumerated() {
                    for v in elem {
                        ret += "\(name)[\(index)].push_back(\(sb(v));\n"
                    }
                }
                return ret
            case .matrix_int(value: let value):
                var ret = "std::vector<std::vector<int> > \(name)(\(value.count));\n"
                for (index, elem) in value.enumerated() {
                    for v in elem {
                        ret += "\(name)[\(index)].push_back(\(v));\n"
                    }
                }
                return ret
            case .matrix_float(value: let value):
                var ret = "std::vector<std::vector<float> > \(name)(\(value.count));\n"
                for (index, elem) in value.enumerated() {
                    for v in elem {
                        ret += "\(name)[\(index)].push_back(\(v));\n"
                    }
                }
                return ret
            case .matrix_string(value: let value):
                var ret = "std::vector<std::vector<std::string> > \(name)(\(value.count));\n"
                for (index, elem) in value.enumerated() {
                    for v in elem {
                        ret += "\(name)[\(index)].push_back(\(v.debugDescription));\n"
                    }
                }
                return ret
        }
    }
    
}
